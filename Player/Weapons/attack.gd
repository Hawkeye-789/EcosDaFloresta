extends Node2D
class_name Attack

@export var damage : float
@export var hitbox : Hitbox

var enemies_inside : Array[Enemy]
var enemy_timers : Array[Timer]

signal hit(target : CharacterBody2D)

func start() -> void:
	pass

func end() -> void:
	queue_free()

func _on_hitbox_body_entered(_body: Node2D) -> void:
	pass

func _on_attack_hitbox_body_exited(_body: Node2D) -> void:
	pass

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
