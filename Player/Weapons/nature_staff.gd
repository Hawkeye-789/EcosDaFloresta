extends Weapon

func _on_cooldown_timer_timeout() -> void:
	var positions : Array[Vector2]
	for i in range(num_attacks):
		positions.append(parent.global_position)
	positions = get_random_position_around(positions, 20)
	attack(positions)

func _ready() -> void:
	super._ready()

func attack(positions : Array[Vector2]) -> void:
	if positions.is_empty():
		return
	AudioManager.play_song("PlayerAttackNature")
	for pos in positions:
		var vines : Attack = attack_scene.instantiate()
		vines = prepare_attack(vines)
		vines.position = pos
		get_tree().get_first_node_in_group("Game").call_deferred("add_child", vines)
		add_effects_to_attack(vines)
		vines.call_deferred("start")
