extends CharacterBody2D
class_name Enemy

@export var move_speed : float = 30.0
@export var exp_drop : float = 1.0

@onready var anim : AnimationPlayer = $AnimationPlayer
var player : CharacterBody2D

const PICKUP_SPAWN_AREA_WIDTH : float = 20

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

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
