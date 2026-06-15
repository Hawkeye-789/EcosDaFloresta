extends Resource
class_name SaveData

@export var coins : int = 0
@export var shop_array : Array[int] = []

func set_shop_array(new_array : Array[int]) -> void:
	shop_array = new_array

func get_shop_array() -> Array[int]:
	return shop_array

func set_coins(amount : int) -> void:
	coins = amount

func get_coins() -> int:
	return coins
