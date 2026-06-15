extends Node2D
class_name SpawnerPath

@export var spawns : Array[EnemySpawnInfo]
@export var path_follow : PathFollow2D
@export var timer : Timer

const BOSS_OFFSET : Vector2 = Vector2(0, -100)

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
signal spawn_enemy(enemy : Enemy)

func get_random_pos(progress_limits : Vector2) -> Vector2:
	path_follow.progress_ratio = randf_range(progress_limits.x, progress_limits.y)
	return path_follow.global_position

func check_if_ended() -> bool:
	return spawns.is_empty()

func _on_timer_timeout() -> void:
	time_passed += 1
	if check_if_ended():
		finished.emit()
		queue_free()
		return
	var spawn : EnemySpawnInfo = spawns.front()
	if spawn.start_time <= time_passed:
		if spawn.end_time > time_passed:
			for i in range(spawn.enemy_count(time_passed)):
				var new_enemy : Enemy = spawn.get_enemy(time_passed)
				new_enemy.position = get_random_pos(spawn_modes_array[spawn.spawn_mode])
				spawn_enemy.emit(new_enemy)
		elif spawn.end_time == time_passed:
			var new_boss : Enemy = spawn.get_boss()
			var final_boss : bool = spawns.size() == 1
			new_boss.position = get_random_pos(spawn_modes_array[SpawnModes.UP]) + BOSS_OFFSET
			timer.stop()
			AudioManager.stop("LevelMusic")
			if final_boss:
				AudioManager.play_song("FinalBossMusic")
			else:
				AudioManager.play_song("BossMusic")
			new_boss.died.connect((func(is_final_boss : bool) -> void:
					if is_final_boss:
						AudioManager.stop("FinalBossMusic")
						AudioManager.play_song("VictoryMusic")
					else:
						AudioManager.stop("BossMusic")
						AudioManager.play_song("LevelMusic")
					timer.start()
					).bind(final_boss)
				)
			spawn_enemy.emit(new_boss)  
			spawns.pop_front()
