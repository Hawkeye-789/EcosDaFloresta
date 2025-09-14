extends Area2D
class_name Hitbox

@export var parent : Node2D
@export var damage : float

signal hit(target: Node2D)

func get_hitbox_parent() -> Node2D:
	return parent

func emit_hit_signal(target : Node2D) -> void:
	hit.emit(target)

func get_damage() -> float:
	return damage
