extends Attack

@export var disappear_timer : Timer

var tick_duration : float
var size : float
var duration : float

func start() -> void:
	hitbox.scale = Vector2(size, size)
	disappear_timer.start(duration)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		hit_function(body)
		var timer := create_new_timer(tick_duration)
		timer.timeout.connect(hit_function.bind(body))
		timer.tree_exited.connect(hit_function.bind(body))
		body.died.connect(func():
			enemies_inside.erase(body))
		enemies_inside.append(body)
		enemy_timers.append(timer)
		body.add_child(timer)

func _on_disappearing_timer_timeout() -> void:
	end()

func _on_attack_hitbox_body_exited(body: Node2D) -> void:
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
