extends Attack
@export var speed : float

var direction : Vector2
var velocity : Vector2 = Vector2.ZERO

func start() -> void:
	velocity = direction * speed
	hitbox.scale = Vector2(size, size)
	disappearing_timer.start(duration)

func _physics_process(delta: float) -> void:
	if !(velocity.is_equal_approx(Vector2.ZERO)):
		position += velocity * delta	
