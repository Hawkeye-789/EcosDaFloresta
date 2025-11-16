extends CharacterBody2D
class_name Enemy

@export var move_speed : float = 30.0
@export var close_distance: float = 0.0
@export var far_distance : float = 0.0
@export var exp_drop : float = 1.0

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var noise : FastNoiseLite = FastNoiseLite.new()
var player : CharacterBody2D

var repelling : bool = false

const PICKUP_SPAWN_AREA_WIDTH : float = 20
const BASE_NOISE_VELOCITY_MULTIPLIER : float = 0.3

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5

func _physics_process(_delta: float) -> void:
	update_state()
	
	var direction = global_position.direction_to(player.global_position)
	if repelling:
		direction *= -1
	velocity = direction * move_speed
	velocity += get_noise_velocity(Time.get_ticks_msec() / 1000.0)
	move_and_slide()

func update_state() -> void:
	var distance: float = global_position.distance_to(player.global_position)

	if not repelling and distance < close_distance:
		repelling = true
	elif repelling and distance > far_distance and !is_zero_approx(close_distance):
		repelling = false

func get_noise_velocity(time: float, velocity_multiplier : float = BASE_NOISE_VELOCITY_MULTIPLIER) -> Vector2:
	var nx = noise.get_noise_1d(time)     
	var ny = noise.get_noise_1d(time + 100)
	var dir = Vector2(nx, ny).normalized()
	return dir * move_speed * velocity_multiplier

func get_noised_velocity(current_velocity : Vector2) -> Vector2:
	return current_velocity.normalized() * move_speed

func _on_hitbox_hit(_target: Node2D) -> void:
	pass

func die() -> void:
	queue_free()

func calculate_pickups(total_xp: int) -> Dictionary:
	var result := {
		"Big": 0,
		"Medium": 0,
		"Small": 0,
	}

	var remaining = total_xp
	var values = [
		{"name": "Big", "value": Exp.ExpValues.Big},
		{"name": "Medium", "value": Exp.ExpValues.Medium},
		{"name": "Small", "value": Exp.ExpValues.Small},
	]

	for v in values:
		var count = remaining / v.value
		result[v.name] = count
		remaining -= count * v.value

	return result

func get_random_position_for_spawn() -> Vector2:
	var min_x = global_position.x - (PICKUP_SPAWN_AREA_WIDTH/2)
	var max_x = global_position.x + (PICKUP_SPAWN_AREA_WIDTH/2)
	var min_y = global_position.y - (PICKUP_SPAWN_AREA_WIDTH/2)
	var max_y = global_position.y + (PICKUP_SPAWN_AREA_WIDTH/2)
	
	return Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)

func spawn_pick_ups() -> void:
	pass

func _on_health_manager_took_damage() -> void:
	anim.play("hitflash")
