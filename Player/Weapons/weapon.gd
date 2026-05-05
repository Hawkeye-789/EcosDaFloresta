extends Node2D
class_name Weapon

@export var cooldown : float:
	set = set_cooldown
@export var damage : float:
	set = set_damage
@export var num_attacks : int:
	set = set_num_attacks
@export var size : float:
	set = set_size
@export var duration : float:
	set = set_duration
@export var tick_duration : float:
	set = set_tick_duration

func set_cooldown(value : float) -> void:
	cooldown = value
func set_damage(value : float) -> void:
	damage = value
func set_num_attacks(value : int) -> void:
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
		var x_offset = (screen_size.x / 2) * 0.7
		var y_offset = (screen_size.y / 2) * 0.7
		var pos : Vector2 = Vector2(
			randf_range(screen_pos.x - x_offset, screen_pos.x + x_offset),
			randf_range(screen_pos.y - y_offset, screen_pos.y + y_offset)
		)
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
