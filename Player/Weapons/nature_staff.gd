extends Weapon

func _on_cooldown_timer_timeout() -> void:
	attack()

func _ready() -> void:
	super._ready()

func set_tick_duration(value : float) -> void:
	super.set_tick_duration(value)
	if vines_node:
		prepare_attack(vines_node)
func set_damage(value : float) -> void:
	super.set_damage(value)
	if vines_node:
		prepare_attack(vines_node)
func set_size(value : float) -> void:
	super.set_size(value)
	if vines_node:
		prepare_attack(vines_node)

var vines_node : Attack

func attack() -> void:
	var vines : Attack = attack_scene.instantiate()
	vines = prepare_attack(vines)
	get_tree().get_first_node_in_group("Player").call_deferred("add_child", vines)
	add_effects_to_attack(vines)
	vines_node = vines
