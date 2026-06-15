extends Attack

@export var growth_speed : float = 60.0

func start() -> void:
	hitbox.scale = Vector2(size, size)
	disappearing_timer.start(duration)

func _process(delta: float) -> void:
	hitbox.scale += Vector2(1, 1) * growth_speed * delta
