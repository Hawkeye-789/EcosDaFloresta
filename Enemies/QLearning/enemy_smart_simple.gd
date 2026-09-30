extends Enemy
class_name EnemySmart

@export var distance_coefficient : float = 2
@export var speed_alpha : float = 0.5
var player_pos : Vector2 = Vector2.ZERO
var player_vel : Vector2 = Vector2.ZERO

func predict_player_pos(delta : float, arrive_time : float) -> Vector2:
	var predicted_increase : Vector2
	if player_pos:
		var pos_diff := player.global_position - player_pos
		var delta_speed : Vector2 = pos_diff / delta
		player_vel = (1 - speed_alpha) * player_vel + speed_alpha * delta_speed
		player_pos = player.global_position
		predicted_increase = player_vel * arrive_time
	else:
		player_pos.x = player.global_position.x
		player_pos.y = player.global_position.y
		player_vel.x = 0.0
		player_vel.y = 0.0
	return predicted_increase

var target_dir : Vector2 = Vector2.ZERO 

func predict_player_direction(delta : float) -> void:
	var distance := global_position.distance_to(player.global_position) / distance_coefficient
	var arrive_time : float = distance / move_speed
	var predicted_player_pos := player.global_position + predict_player_pos(delta, arrive_time)
	if to_local(predicted_player_pos).length() < to_local(player.global_position).length():
		target_dir = to_local(predicted_player_pos).normalized()
	else:
		target_dir = to_local(player.global_position).normalized()

func _physics_process(delta: float) -> void:
	predict_player_direction(delta)
	if !being_knocked:
		velocity = target_dir * move_speed
		#velocity += get_noise_velocity(Time.get_ticks_msec() / 1000.0)
	if !sleeping:
		move_and_slide()
