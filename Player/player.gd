extends CharacterBody2D
class_name Player

@export var base_speed : float
@export var player_info : PlayerInfo
@export var spawner_remote_transform : RemoteTransform2D

func _ready() -> void:
	player_info.range_changed.connect(change_range)
	player_info.call_deferred("initialize_exp_bar")
	var spawner_node : SpawnerPath = get_tree().get_first_node_in_group("Spawner")
	if spawner_node:
		spawner_node.global_position = spawner_remote_transform.global_position
		spawner_remote_transform.remote_path = spawner_node.get_path_to(spawner_remote_transform)

func _physics_process(_delta: float) -> void:
	var dir_x : int = int(Input.get_axis("left", "right"))
	var dir_y : int = int(Input.get_axis("up", "down"))
	velocity = Vector2(dir_x, dir_y).normalized() * base_speed * player_info.get_speed_multiplier()
	move_and_slide()

func _on_pick_up_collector_area_entered(area: Area2D) -> void:
	var pick_up : PickUp = area.get_parent()
	pick_up.start_moving()

func get_exp(value : int) -> void:
	print("Got ", value, " exp!")
	player_info.add_exp(value)

func change_range() -> void:
	$Areas/Hitbox.scale = Vector2(1, 1) * player_info.get_range_multiplier()

func _on_hitbox_hit(_target: Node2D) -> void:
	#player_info.add_speed_multiplier(0.5)
	pass
