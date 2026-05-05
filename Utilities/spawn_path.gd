extends Path2D
class_name SpawnerPath

@export var spawns : Array[EnemySpawnInfo]
@export var path_follow : PathFollow2D

enum SpawnModes { WHOLE_SCREEN = 0, UP = 1, RIGHT = 2, DOWN = 3, LEFT = 4 }
var spawn_modes_array : Array[Vector2] = [
	Vector2(0.0, 1.0),
	Vector2(0.0, 0.32),
	Vector2(0.32, 0.5),
	Vector2(0.5, 0.82),
	Vector2(0.82, 1.0)
]
var time_passed : float = 0.0

signal finished

func get_random_pos(progress_limits : Vector2) -> Vector2:
	path_follow.progress_ratio = randf_range(progress_limits.x, progress_limits.y)
	return path_follow.global_position

func check_if_ended(current_time : float) -> bool:
	for spawn in spawns:
		if current_time < spawn.end_time:
			return false
	return true

func _on_timer_timeout() -> void:
	time_passed += 1
	for spawn in spawns:
		if spawn.start_time <= time_passed and spawn.end_time >= time_passed:
			var enemy_path : String = str(spawn.enemy.resource_path)
			var new_enemy_scene : PackedScene = load(enemy_path)
			for i in range(spawn.enemy_num):
				var new_enemy : Enemy = new_enemy_scene.instantiate()
				new_enemy.position = get_random_pos(spawn_modes_array[spawn.spawn_mode])
				get_tree().get_first_node_in_group("World").call_deferred("add_child", new_enemy)
	if check_if_ended(time_passed):
		finished.emit()
