extends Weapon

@export var size_multiplier : float = 1.5

func _on_cooldown_timer_timeout() -> void:
	var enemies : Array[Enemy] = get_closest_enemy(num_attacks)
	attack(enemies)
 
func set_size(value : float) -> void:
	size = value * size_multiplier

func attack(enemies : Array[Enemy]) -> void:
	for enemy in enemies:
		if enemy:
			var fire_ball : Attack = attack_scene.instantiate()
			fire_ball.direction = to_local(enemy.position).normalized()
			fire_ball.position = global_position
			fire_ball = prepare_attack(fire_ball)
			get_tree().get_first_node_in_group("World").call_deferred("add_child", fire_ball)
			add_effects_to_attack(fire_ball)
			fire_ball.call_deferred("start")
