extends Attack

func start() -> void:
	hitbox.scale = Vector2(size, size)
	disappearing_timer.start(duration)
