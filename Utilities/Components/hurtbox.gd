extends Area2D
class_name Hurtbox

@export var parent : Node2D

signal got_hit

func _on_area_entered(area: Area2D) -> void:
	var hitbox : Hitbox = area
	hitbox.emit_hit_signal(parent)
