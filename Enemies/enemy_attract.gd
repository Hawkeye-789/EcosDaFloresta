extends Enemy
class_name EnemyAttract

@export var threat_distance : float = 300
@export var threat_repulsion_min : float = 10.0
@export var threat_repulsion_max : float = 30.0
@export var player_attraction_force : float = 30.0
@export var player_attraction_increase_threshold : float = 200.0
@export var player_attaction_increase_coefficient : float = 3.0
@export var frame_delta : int = 15

var attraction_vectors : Array[Vector2] = []
var attraction_forces : Array[float] = []
var target_direction : Vector2 = Vector2.ZERO
var current_frame : int = 60

func get_total_attraction() -> Vector2:
	assert(attraction_vectors.size() == attraction_forces.size(), "Vetores de atração e intensidade não tem o mesmo tamanho!!")
	var result : Vector2 = Vector2.ZERO
	for i in range(attraction_vectors.size()):
		var v : Vector2 = attraction_vectors[i] * attraction_forces[i]
		result += v
	return result

func get_attraction() -> Vector2:
	return to_local(player.global_position)

func get_repulsions() -> Array[Vector2]:
	var repulsions : Array[Vector2] = []
	var attacks : Array[Node] = get_tree().get_nodes_in_group("Attacks")
	for att in attacks:
		var att_dir : Vector2 = to_local(att.global_position)
		if att_dir.length() < threat_distance:
			repulsions.push_back(att_dir)
	return repulsions

func get_direction() -> Vector2:
	var dir : Vector2 = Vector2.ZERO
	var attraction := get_attraction()
	var repulsions := get_repulsions()
	print("Vazio: ", repulsions.is_empty())
	attraction = attraction.normalized() * player_attraction_force
	if attraction.length() < player_attraction_increase_threshold:
		attraction *= player_attaction_increase_coefficient 
	dir += attraction
	if not repulsions.is_empty():
		for rep in repulsions:
			var distance_ratio : float = rep.length() / threat_distance
			var repulsion_force : float = threat_repulsion_min + (threat_repulsion_max - threat_repulsion_min) * distance_ratio
			dir += rep * repulsion_force
	return dir.normalized()

func _physics_process(_delta: float) -> void:
	current_frame += 1
	if current_frame >= frame_delta:
		target_direction = get_direction()
	if !being_knocked:
		velocity = target_direction * move_speed
		velocity += get_noise_velocity(Time.get_ticks_msec() / 1000.0) / 2
	if !sleeping:
		move_and_slide()
