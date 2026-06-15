extends Node

signal coins_changed(new_amount : int, instant : bool)

var coins : int = 0:
	set(value):
		coins = value
		SaveManager.save_data.set_coins(coins)

func add_coins(amount : int) -> void:
	coins += amount
	coins_changed.emit(coins, false)

func subtract_coins(amount : int) -> void:
	coins = max(0, coins - amount)
	coins_changed.emit(coins, false)

func set_coins(amount : int) -> void:
	coins = amount
	coins_changed.emit(coins, true)

func has_coins(amount : int) -> bool:
	return coins >= amount
