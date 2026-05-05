extends Weapon

func _on_cooldown_timer_timeout() -> void:
	var positions : Array[Vector2] = get_random_pos_on_screen(num_attacks)
	attack(positions)

func attack(positions : Array[Vector2]) -> void:
	for pos in positions:
		var whirlwind : Attack = attack_scene.instantiate()
		whirlwind.position = pos
		whirlwind = prepare_attack(whirlwind)
		get_tree().get_first_node_in_group("World").call_deferred("add_child", whirlwind)
		add_effects_to_attack(whirlwind)
		whirlwind.call_deferred("start")
