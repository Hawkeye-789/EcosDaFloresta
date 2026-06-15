@tool
extends Resource
class_name EnemySpawnInfo

@export var start_time : float = 5.0
@export var end_time : float = 5.0

@export var upgrade_count : int = 0:
	set(value):
		var interval := end_time - start_time
		var num_parts := value + 1
		var timestamps : Array[float] = []
		for i in range(value):
			var new_timestamp := start_time + ((i + 1) * interval / num_parts)
			timestamps.append(new_timestamp)
		upgrade_timestamps = timestamps
		upgrade_count = value

@export var upgrade_timestamps : Array[float] = []
@export var enemy_scene : PackedScene
@export var boss_scene : PackedScene
@export var enemy_num_min : int
@export var enemy_num_max : int
@export var spawn_delay : float
@export var spawn_mode : SpawnerPath.SpawnModes

func get_enemy(timestamp: float) -> Enemy:
	var enemy : Enemy = enemy_scene.instantiate()
	var count : int = 0
	for time in upgrade_timestamps:
		if time < timestamp:
			count += 1
	enemy.upgrade(count)
	return enemy

func enemy_count(timestamp : float) -> int:
	var count : int = enemy_num_min
	var step : float = 0.0
	step = float(enemy_num_max - enemy_num_min) / upgrade_count
	for time in upgrade_timestamps:
		if time < timestamp:
			count = floor(count + step)
	return count

func get_boss() -> Boss:
	return boss_scene.instantiate()
