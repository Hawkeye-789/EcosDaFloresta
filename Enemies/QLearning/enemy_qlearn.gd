extends EnemyFollow
class_name EnemyFollowQLearning

const HEALTH_THRESHOLD_H : float = 0.7
const HEALTH_THRESHOLD_M : float = 0.4
const DISTANCE_THRESHOLD_VF : float = 550
const DISTANCE_THRESHOLD_F : float = 350
const DISTANCE_THRESHOLD_C : float = 150
const THREAT_THRESHOLD : float = 100

const LOST_HEALTH_REWARD : float = -1.0
const DISTANCE_INCREASE_REWARD : float = -5.0
const DISTANCE_DECREASE_REWARD : float = 0.5
const DEATH_REWARD : float = -5
const DAMAGE_DEALT_REWARD : float = 1
const THREAT_DISTANCE_INCREASE_REWARD : float = 0.1
const THREAT_DISTANCE_DECREASE_REWARD : float = -1.0

@export var frame_delta : int = 15
@export var use_predict_pos : bool = false

@export var qtable_epsilon : float = 0.2
@export var qtable_alpha : float = 0.05
@export var qtable_gamma : float = 0.9
var current_frame : int = 0
var qlearn_state : QLearnState = QLearnState.new()

var prev_health : float
var prev_pos : Vector2
var prev_threat_state : QLearnState.ThreatLevel
var queued_damage_reward : float = 0

var actions_arr : Array[Vector2] = [
	Vector2(1, 0),
	Vector2(1, 1).normalized(),
	Vector2(0, 1),
	Vector2(-1, 1).normalized(),
	Vector2(-1, 0),
	Vector2(-1, -1).normalized(),
	Vector2(0, -1),
	Vector2(1, -1).normalized()
]
var qlearn_manager : QLearnManager

var previous_state_index : int = -1
var previous_action : QLearnManager.Actions
var current_threat_pos : Vector2 = Vector2(0, 0)

func _ready() -> void:
	super._ready()
	prev_health = health_man.max_health
	prev_pos = global_position
	prev_threat_state = QLearnState.ThreatLevel.NO_THREAT

func qlearn_process() -> void:
	if use_predict_pos:
		get_current_state(target_dir)
	else:
		get_current_state(player.global_position - global_position)
	var state_index: int = qlearn_state.get_index()
	var reward: float = qlearn_get_reward()
	#print("\n========== Q-LEARNING [%s] ==========" % get_instance_id())
	#print("Estado atual: ", get_state_debug())
	#print("State index: ", state_index)
	#print("Recompensa calculada: ", reward)
	if previous_state_index != -1:
		#var old_q: float = qlearn_manager.q_table[previous_state_index][previous_action]
		qlearn_manager.update_q_table(
			previous_state_index,
			previous_action,
			reward,
			state_index,
			qtable_alpha,
			qtable_gamma
		)
		#var new_q: float = qlearn_manager.q_table[previous_state_index][previous_action]
		#print(
			#"Atualização Q: state=%d action=%s"
			#% [
				#previous_state_index,
				#QLearnManager.Actions.keys()[previous_action]
			#]
		#)
		#print("Q antigo: ", old_q)
		#print("Q novo:   ", new_q)
	var current_action: QLearnManager.Actions = qlearn_manager.get_action(
		state_index,
		qtable_epsilon
	)
	target_dir = actions_arr[current_action as int]
	#print("Epsilon: ", qtable_epsilon)
	#print("Ação escolhida: ", QLearnManager.Actions.keys()[current_action])
	#print("======================================")
	previous_state_index = state_index
	previous_action = current_action

func get_current_state(player_dir : Vector2) -> void:
	var player_sector : int = round(player_dir.angle() / (PI / 4))
	player_sector = posmod(player_sector, 8)
	qlearn_state.player_dir = player_sector as QLearnState.PlayerDirection
	
	var threat_dir : Vector2 = check_threat()
	if threat_dir.is_equal_approx(Vector2.ZERO):
		qlearn_state.threat = QLearnState.ThreatLevel.NO_THREAT
		qlearn_state.threat_dir = QLearnState.ThreatDirection.NONE
	else:
		qlearn_state.threat = QLearnState.ThreatLevel.THREAT
		var threat_sector : int = round(threat_dir.angle() / (PI / 4))
		threat_sector = posmod(threat_sector, 8)
		qlearn_state.threat_dir = threat_sector as QLearnState.ThreatDirection
	
	var player_dist : float = global_position.distance_to(player.global_position)
	if player_dist > DISTANCE_THRESHOLD_VF:
		qlearn_state.distance = QLearnState.DistanceLevel.VERY_FAR
	elif player_dist > DISTANCE_THRESHOLD_F:
		qlearn_state.distance = QLearnState.DistanceLevel.FAR
	elif player_dist > DISTANCE_THRESHOLD_C:
		qlearn_state.distance = QLearnState.DistanceLevel.CLOSE
	else:
		qlearn_state.distance = QLearnState.DistanceLevel.VERY_CLOSE

func check_threat() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	var attacks : Array[Node] = get_tree().get_nodes_in_group("Attacks")
	if attacks.is_empty():
		return dir
	var closest_distance : float = INF
	for att in attacks:
		if not att is Attack:
			continue
		var attack : Attack = att as Attack
		var att_relative_pos : Vector2 = attack.global_position - global_position
		var att_offset : float = attack.size / 2
		var distance_to_attack : float = att_relative_pos.length() - att_offset
		if distance_to_attack <= THREAT_THRESHOLD:
			if distance_to_attack < closest_distance:
				closest_distance = distance_to_attack
				current_threat_pos = attack.global_position
				dir = att_relative_pos.normalized()
	return dir


func dealt_damage() -> void:
	queued_damage_reward = DAMAGE_DEALT_REWARD

func qlearn_get_reward() -> float:
	var reward : float = 0.0
	var health_diff : float = prev_health - health_man.health 
	reward += health_diff * LOST_HEALTH_REWARD
	prev_health = health_man.health
	var new_pos : Vector2 = global_position 
	var p_pos : Vector2 = player.global_position
	var distance_diff : float = (new_pos - p_pos).length() - (prev_pos - p_pos).length()
	if distance_diff < 0.0:
		reward += DISTANCE_DECREASE_REWARD * abs(distance_diff)
	else:
		reward += DISTANCE_INCREASE_REWARD
		 
	if qlearn_state.threat == QLearnState.ThreatLevel.THREAT:
		if prev_pos != null:
			var threat_distance_diff : float = (new_pos - current_threat_pos).length() - (prev_pos - current_threat_pos).length()
			if threat_distance_diff > 0.0:
				reward += THREAT_DISTANCE_INCREASE_REWARD * threat_distance_diff
			elif threat_distance_diff < 0.0:
				reward += THREAT_DISTANCE_DECREASE_REWARD * abs(threat_distance_diff)
	
	prev_pos = new_pos
	prev_threat_state = qlearn_state.threat
	reward += queued_damage_reward
	queued_damage_reward = 0.0
	return reward

func _physics_process(_delta: float) -> void:
	current_frame += 1
	if current_frame >= frame_delta:
		current_frame = 0
		if !sleeping:
			qlearn_process()
			#qtable_epsilon *= 0.9
	if !being_knocked:
		velocity = actions_arr[previous_action as int] * move_speed
	if !sleeping:
		move_and_slide()

func die() -> void:
	if previous_state_index != -1:
		qlearn_manager.update_q_table_final(previous_state_index, previous_action, DEATH_REWARD, qtable_alpha)
	super.die()

func get_state_debug() -> String:
	return (
		"HP=%s | Dist=%s | Threat=%s | PlayerDir=%s | ThreatDir=%s"
		% [
			QLearnState.DistanceLevel.keys()[qlearn_state.distance],
			QLearnState.ThreatLevel.keys()[qlearn_state.threat],
			QLearnState.PlayerDirection.keys()[qlearn_state.player_dir],
			QLearnState.ThreatDirection.keys()[qlearn_state.threat_dir]
		]
	)
