extends CardInfo
class_name WeaponBuffCardInfo

@export var buff_dictionary : Dictionary[String, float] = {}
@export var added_affect : PackedScene

func effect() -> void:
	var player : Player = PlayerManager.get_player()
	#debug
	#for property in buff_dictionary.keys():
			#print(property, buff_dictionary.get(property))
	if player:
		for property in buff_dictionary.keys():
			player.current_weapon.set(property, buff_dictionary.get(property))
