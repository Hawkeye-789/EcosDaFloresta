extends Node

@export var obstacle_scenes : Array[PackedScene]
@export var min_distance_to_player : float = 800.0
@export var max_distance_to_player : float = 1200.0
@export var spawn_delay : float = 15.0
@export var spawn_number : int = 1
@export var spawn_timer : Timer

var parent : Game
var player : Player

func _ready() -> void:
	parent = get_parent()
	assert(parent != null, "Pai de ObstacleSpawner não existe!")
	player = get_tree().get_first_node_in_group("Player")
	assert(player != null, "Player não encontrado em ObstacleSpawner!")
	spawn_obstacles()
	spawn_timer.start(spawn_delay)

func spawn_obstacles() -> void:
	var player_pos := player.position
	for i in range(spawn_number):
		var rand_dist := randf_range(min_distance_to_player, max_distance_to_player)
		var rand_angle := randf_range(0.0, 2 * PI)
		var spawn_pos := (Vector2.RIGHT * rand_dist).rotated(rand_angle)
		spawn_pos += player_pos
		var spawn : Obstacle = obstacle_scenes.pick_random().instantiate()
		spawn.position = spawn_pos
		parent.call_deferred("add_child", spawn)
