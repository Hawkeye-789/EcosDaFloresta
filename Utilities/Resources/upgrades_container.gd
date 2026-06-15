extends Node
class_name ShopUpgradesContainer

@export var perma_upgrades : Array[ShopCardInfo]

func _ready() -> void:
	PlayerManager.player_connected.connect(apply_upgrades)
	load_upgrades()

func load_upgrades() -> void:
	SaveManager.load_save()
	var shop_array : Array[int] = SaveManager.save_data.get_shop_array()
	if shop_array.size() == perma_upgrades.size():
		for i in range(perma_upgrades.size()):
			perma_upgrades[i].num_picks = shop_array[i]
	else:
		for i in range(perma_upgrades.size()):
			perma_upgrades[i].num_picks = 0
		push_warning("Array de upgrades salvos tem tamanho: ", shop_array.size(), " enquanto o do jogo possui: ", perma_upgrades.size())

func save_upgrades() -> void:
	var new_shop_array : Array[int]
	for upgrade in perma_upgrades:
		new_shop_array.append(upgrade.num_picks)
	SaveManager.save_data.shop_array.clear()
	SaveManager.save_data.shop_array = new_shop_array
	SaveManager.save()

func get_perma_upgrades() -> Array[ShopCardInfo]:
	return perma_upgrades

func apply_upgrades() -> void:
	for upgrade in perma_upgrades:
		for i in range(upgrade.num_picks):
			upgrade.apply_effect()

func check() -> void:
	for upgrade in perma_upgrades:
		print(upgrade.num_picks, " - ")
