extends Weapon

func _on_cooldown_timer_timeout() -> void:
	var positions : Array[Vector2] = get_random_pos_on_screen(floor(num_attacks))
	attack(positions)

func attack(positions : Array[Vector2]) -> void:
	if positions.is_empty():
		return
	AudioManager.play_song("PlayerAttackWitch")
	for pos in positions:
		var potion : Attack = attack_scene.instantiate()
		potion.position = pos
		potion = prepare_attack(potion)
		get_tree().get_first_node_in_group("Game").call_deferred("add_child", potion)
		add_effects_to_attack(potion)
		potion.call_deferred("start")
