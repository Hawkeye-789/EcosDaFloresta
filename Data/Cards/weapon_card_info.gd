extends CardInfo
class_name WeaponCardInfo

@export var weapon_scene : PackedScene
@export var legend_info : LegendInfo

func apply_effect() -> void:
	var weapon : Weapon = weapon_scene.instantiate()
	PlayerManager.give_player_weapon(weapon)
