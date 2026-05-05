extends Attack

@export var disappearing_timer : Timer
@export var speed : float
@export var duration : float
@export var size : float

var direction : Vector2
var velocity : Vector2 = Vector2.ZERO

func start() -> void:
	velocity = direction * speed
	disappearing_timer.start(duration)
	hitbox.scale = Vector2(size, size)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		hit_function(body)

func _physics_process(delta: float) -> void:
	if !(velocity.is_equal_approx(Vector2.ZERO)):
		position += velocity * delta	
