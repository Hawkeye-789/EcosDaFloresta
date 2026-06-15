extends CardInfo
class_name WeaponBuffCardInfo

@export var buff_dictionary : Dictionary[String, float] = {}
@export var added_effect : PackedScene

func apply_effect() -> void:
	var player : Player = PlayerManager.get_player()
	#debug
	#for property in buff_dictionary.keys():
			#print(property, buff_dictionary.get(property))
	if player:
		for property : String in buff_dictionary.keys():
			player.current_weapon.set(property, buff_dictionary.get(property))
		if added_effect:
			player.equip_weapon_effect(added_effect.instantiate())
