extends Enemy

@onready var exp_scene : PackedScene = preload("res://Utilities/PickUps/exp.tscn")

func spawn_pick_ups() -> void:
	var drops = calculate_pickups(exp_drop)

	for type in drops.keys():
		for i in range(drops[type]):
			var exp_pickup : Exp = exp_scene.instantiate()
			
			match type:
				"Small": exp_pickup.set_value(Exp.ExpValues.Small)
				"Medium": exp_pickup.set_value(Exp.ExpValues.Medium)
				"Big": exp_pickup.set_value(Exp.ExpValues.Big)
			
			exp_pickup.global_position = get_random_position_for_spawn()
			get_tree().current_scene.call_deferred("add_child", exp_pickup)

func die() -> void:
	spawn_pick_ups()
	super.die()
