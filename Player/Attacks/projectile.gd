extends Node2D
class_name Projectile

enum ProjectileMode { HitOnce = 0, PassThrough = 1}
@export var mode : ProjectileMode = 0

@export var hitbox : Hitbox

signal hit(target : Node2D)

func set_damage(multiplier : float) -> void:
	hitbox.damage *= multiplier

func _on_hitbox_hit(target: Node2D) -> void:
	hit.emit(target)
	match mode:
		0:
			pass
		1:
			queue_free()
		_:
			printerr("This should not have happened")
	hit.emit(target)
