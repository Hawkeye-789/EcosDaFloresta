extends CardInfo
class_name PassiveCardInfo

@export var max_picks : int = 1
@export var property_increase : Dictionary[String, float]
@export var child_scene : PackedScene
@export var weapon_effect_scene : PackedScene


var num_picks : int = 0

func effect() -> void:
	if property_increase:
		for key in property_increase.keys():
			if key is String:
				PlayerManager.change_player_property(key, property_increase[key])
	elif child_scene:
		var scene := child_scene.instantiate()
		PlayerManager.give_player_node_passive(scene)
	elif weapon_effect_scene:
		var weapon_effect : Effect = weapon_effect_scene.instantiate()
		PlayerManager.give_player_weapon_effect(weapon_effect)
	else:
		assert(false, "Effect não tinha nenhuma das opções definidas! Em: " + resource_name)
	num_picks += 1

func can_be_picked() -> bool:
	return num_picks < max_picks
