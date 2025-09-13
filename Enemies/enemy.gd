extends CharacterBody2D

@onready var exp_scene : PackedScene = preload("res://Utilities/PickUps/exp.tscn")

@export var move_speed : float = 30.0
var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * move_speed
	
	if Input.is_action_pressed("ui_accept"):
		spawn_exp()
	move_and_slide()

func spawn_exp() -> void:
	var exp_dot : Exp = exp_scene.instantiate()
	exp_dot.set_value(Exp.ExpValues.Big)
	get_parent().call_deferred("add_child", exp_dot)
	queue_free()

func _on_hitbox_hit(target: Node2D) -> void:
	print("Uau")
