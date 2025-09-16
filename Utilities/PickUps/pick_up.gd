extends Node2D
class_name PickUp

var player : Player = null
var direction : Vector2 = Vector2.ZERO
@export var top_move_speed : float = 100.0
@export var sprite : Sprite2D
@export var collision_area : Area2D

var current_move_speed : float = 0.0
var can_move : bool = false
var move_tween : Tween = null

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func start_moving() -> void:
	can_move = true

func _physics_process(delta: float) -> void:
	if player and !can_move and !move_tween:
		move_tween = create_tween()
		move_tween.tween_property(self, "current_move_speed", top_move_speed, 1).set_ease(Tween.EASE_IN)
	if can_move:
		direction = global_position.direction_to(player.global_position) * current_move_speed
		position += direction * delta

func apply_effect(_target : Node2D) -> void:
	sprite.visible = false
	queue_free()
