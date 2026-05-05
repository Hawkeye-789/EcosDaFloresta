extends Hitbox

@export var explosion_damage : float = 2
@export var knockback_force : float = 60
@export var stun_duration : float = 0.2

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.health_man.take_damage(explosion_damage)
		var direction : Vector2 = to_local(body.position).normalized()
		var knockback : Vector2 = direction * knockback_force
		body.knockback(knockback, stun_duration)

func _on_disappearing_timer_timeout() -> void:
	queue_free()
