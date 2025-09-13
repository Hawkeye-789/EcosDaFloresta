extends Node2D
class_name PickUp

var player : Player = null
var direction : Vector2 = Vector2.ZERO
@export var move_speed : float = 100.0
@export var sprite : Sprite2D
@export var collision_area : Area2D

func set_player(player_node : Player) -> void:
	player = player_node

func _physics_process(delta: float) -> void:
	if player:
		direction = global_position.direction_to(player.global_position) * move_speed
		position += direction * delta

func apply_effect(_target : Node2D) -> void:
	sprite.visible = false
	queue_free()
