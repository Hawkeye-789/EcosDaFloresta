extends Attack

var size : float
var duration : float
var tick_duration : float = 1.0
@export var disappear_timer : Timer

func start() -> void:
	hitbox.scale = Vector2(size, size)
	disappear_timer.start(duration)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		hit_function(body)

func _on_disappearing_timer_timeout() -> void:
	end()
