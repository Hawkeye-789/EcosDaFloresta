extends Node2D
class_name Attack

@export var damage : float
@export var hitbox : Hitbox
@export var disappearing_timer : Timer

var tick_duration : float
var enemies_inside : Array[Enemy]
var enemy_timers : Array[Timer]
var size : float
var duration : float

signal hit(target : CharacterBody2D)

func start() -> void:
	pass

func end() -> void:
	queue_free()

func create_new_timer(wait_time : float) -> Timer:
	var new_timer : Timer = Timer.new()
	new_timer.autostart = true
	new_timer.one_shot = false
	new_timer.wait_time = wait_time
	return new_timer

func hit_function(enemy : Enemy) -> void:
	hit.emit(enemy)
	enemy.health_man.take_damage(damage)

func reconstruct_enemy_array() -> void:
	var aux_enemy_array : Array[Enemy] = []
	for enemy in enemies_inside:
		if is_instance_valid(enemy) and enemy.is_inside_tree() and !(enemy.is_queued_for_deletion()):
			aux_enemy_array.append(enemy)
	enemies_inside.clear()
	enemies_inside = aux_enemy_array
	
	var aux_timer_array : Array[Timer] = []
	for timer in enemy_timers:
		if is_instance_valid(timer) and timer.is_inside_tree() and !(timer.is_queued_for_deletion()):
			aux_timer_array.append(timer)
	enemy_timers.clear()
	enemy_timers = aux_timer_array

func hitbox_entered_tick(body : Node2D) -> void:
	if body is Enemy:
		hit_function(body)
		var timer := create_new_timer(tick_duration)
		timer.timeout.connect(hit_function.bind(body))
		timer.tree_exited.connect(hit_function.bind(body))
		body.died.connect(func() -> void:
			enemies_inside.erase(body))
		enemies_inside.append(body)
		enemy_timers.append(timer)
		body.add_child(timer)

func hitbox_exited_tick(body: Node2D) -> void:
	if !(body.is_inside_tree()) or body.is_queued_for_deletion():
		return
	reconstruct_enemy_array()
	var enemy_idx : int = enemies_inside.find(body)
	if enemy_idx < 0: return
	var timer : Timer = enemy_timers.get(enemy_idx)
	if is_instance_valid(timer) and timer.is_inside_tree():
		timer.queue_free()
		enemy_timers.erase(timer)
	enemies_inside.erase(body)

func hitbox_entered_one_time(body : Node2D) -> void:
	if body is Enemy:
		hit_function(body)
