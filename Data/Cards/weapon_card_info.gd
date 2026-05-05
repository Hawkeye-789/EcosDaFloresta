extends CardInfo
class_name WeaponCardInfo

@export var weapon_scene : PackedScene

func effect() -> void:
	var weapon : Weapon = weapon_scene.instantiate()
	PlayerManager.give_player_weapon(weapon)
