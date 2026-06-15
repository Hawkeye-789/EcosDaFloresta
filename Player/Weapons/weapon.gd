extends Node2D
class_name Weapon

var parent : Player

@export var cooldown : float:
	set = set_cooldown, get = get_cooldown
@export var damage : float:
	set = set_damage, get = get_damage
@export var num_attacks : float:
	set = set_num_attacks, get = get_num_attacks
@export var size : float:
	set = set_size, get = get_size
@export var duration : float:
	set = set_duration, get = get_duration
@export var tick_duration : float:
	set = set_tick_duration, get = get_tick_duration

func get_cooldown() -> float:
	if parent:
		return cooldown * parent.cooldown_mult
	else:
		return cooldown
func get_damage() -> float:
	if parent:
		return damage * parent.damage_mult
	else:
		return damage
func get_num_attacks() -> float:
	if parent:
		return num_attacks * parent.num_attacks_mult
	else:
		return num_attacks
func get_size() -> float:
	if parent:
		return size * parent.size_mult
	else:
		return size
func get_duration() -> float:
	if parent:
		return duration * parent.duration_mult
	else:
		return duration
func get_tick_duration() -> float:
	#if parent:
		#return tick_duration * parent.tick_duration_mult
	#else:
		return tick_duration

func set_cooldown(value : float) -> void:
	cooldown = value
func set_damage(value : float) -> void:
	damage = value
func set_num_attacks(value : float) -> void:
	num_attacks = value
func set_size(value : float) -> void:
	size = value
func set_duration(value : float) -> void:
	duration = value
func set_tick_duration(value : float) -> void:
	tick_duration = value

@export var cooldown_timer : Timer
@export var attack_scene : PackedScene

var attack_effects : Array[Effect]

func _ready() -> void:
	cooldown_timer.start(cooldown)

func _on_cooldown_timer_timeout() -> void:
	pass

func get_random_pos_on_screen(num : int = 1) -> Array[Vector2]:
	var screen_size := get_viewport_rect().size
	var screen_pos := to_global(get_viewport().get_camera_2d().position)
	var positions : Array[Vector2] = []
	for i in range(num):
		var x_offset := (screen_size.x / 2) * 0.7
		var y_offset := (screen_size.y / 2) * 0.7
		var pos : Vector2 = Vector2(
			randf_range(screen_pos.x - x_offset, screen_pos.x + x_offset),
			randf_range(screen_pos.y - y_offset, screen_pos.y + y_offset)
		)
		positions.append(pos)
	return positions

func get_random_position_around(pivots : Array[Vector2], max_distance : float = 150.0) -> Array[Vector2]:
	var positions : Array[Vector2]
	for pivot in pivots:
		var distance : float = randf_range(0.0, max_distance)
		var offset := Vector2.RIGHT * distance
		offset = offset.rotated( (2 * PI) * randf())
		var pos := pivot + offset
		positions.append(pos)
	return positions

func get_closest_enemy(num : int = 1) -> Array[Enemy]:
	var enemies : Array[Node] = get_tree().get_nodes_in_group("Enemies")
	var enemies_to_return : Array[Enemy] = []
	for i in range(num):
		var closest_dist : float = INF
		var closest_enemy : Enemy
		for enemy in enemies:
			if enemy is Enemy:
				if to_local(enemy.global_position).length() < closest_dist:
					if enemies_to_return.find(enemy) < 0:
						closest_dist = to_local(enemy.global_position).length()
						closest_enemy = enemy
		enemies.erase(closest_enemy)
		enemies_to_return.append(closest_enemy)
	return enemies_to_return

func prepare_attack(attack : Attack) -> Attack:
	if "damage" in attack:
		attack.damage = damage
	if "size" in attack:
		attack.size = size
	if "duration" in attack:
		attack.duration = duration
	if "tick_duration" in attack:
		attack.tick_duration = tick_duration
	return attack

func add_new_effect(effect : Effect) -> void:
	attack_effects.append(effect)

func add_effects_to_attack(attack : Attack) -> void:
	for effect in attack_effects:
		var new_effect := effect.duplicate()
		attack.add_child(new_effect)
