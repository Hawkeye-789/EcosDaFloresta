extends Control
class_name UpgradeShop

@export var confirm_layer : CanvasLayer
@export var confirm_shop_card : ShopCard
@export var confirm_name_label : Label
@export var confirm_button : Button

@export var contents_vbox : VBoxContainer
@export var name_label : Label
@export var description_label : Label
@export var times_bought_label : Label
@export var buy_button : Button
@export var poor_label : Label
@export var upgrades_grid : GridContainer
@export var shop_card_scene : PackedScene
@export var upgrades_container : ShopUpgradesContainer

var upgrades : Array[ShopCardInfo] = []

signal back

func create_shop() -> void:
	upgrades_container.load_upgrades()
	upgrades = upgrades_container.get_perma_upgrades()
	assert(!upgrades.is_empty(), "Upgrades estão vazios na Loja!!!")
	for i in range(upgrades.size()):
		var new_shop_card : ShopCard = shop_card_scene.instantiate()
		new_shop_card.fill_in(upgrades[i].image, upgrades[i].name)
		new_shop_card.change_soldout(!upgrades[i].can_be_picked())
		new_shop_card.set_cost(upgrades[i].cost)
		new_shop_card.pressed.connect(show_upgrade_info.bind(i))
		upgrades_grid.call_deferred("add_child", new_shop_card)
	poor_label.visible = false
	contents_vbox.visible = false

func show_upgrade_info(upgrade_index : int) -> void:
	name_label.text = upgrades[upgrade_index].name
	description_label.text = upgrades[upgrade_index].description
	times_bought_label.text = str(upgrades[upgrade_index].num_picks) + "/" + str(upgrades[upgrade_index].max_picks)
	if show_buy_button(upgrade_index):
		if not can_buy(upgrade_index):
			show_poor_label()
	contents_vbox.visible = true

func show_purchase_confirm(upgrade_index : int) -> void:
	confirm_name_label.text = upgrades[upgrade_index].name
	confirm_shop_card.fill_in(upgrades[upgrade_index].image, upgrades[upgrade_index].name)
	confirm_shop_card.set_cost(upgrades[upgrade_index].cost)
	confirm_layer.visible = true
	for connection : Dictionary in confirm_button.pressed.get_connections():
		confirm_button.pressed.disconnect(connection.callable)
	confirm_button.pressed.connect(manage_purchase.bind(upgrade_index))

func hide_purchase_confirm() -> void:
	confirm_layer.visible = false

func can_buy(upgrade_index : int) -> bool:
	return CoinManager.has_coins(upgrades[upgrade_index].cost) 

func manage_purchase(upgrade_index : int) -> void:
	if can_buy(upgrade_index):
		upgrades[upgrade_index].num_picks += 1
		(upgrades_grid.get_child(upgrade_index) as ShopCard).change_soldout(!upgrades[upgrade_index].can_be_picked())
		CoinManager.subtract_coins(upgrades[upgrade_index].cost)
		confirm_layer.visible = false
		show_upgrade_info(upgrade_index)
	else:
		print("Vai trabalhar seu pobre fudido!!")

func _ready() -> void:
	create_shop()

func show_buy_button(upgrade_index: int) -> bool:
	poor_label.visible = false
	buy_button.visible = upgrades[upgrade_index].can_be_picked()
	if not upgrades[upgrade_index].can_be_picked():
		return false
	else:
		for connection : Dictionary in buy_button.pressed.get_connections():
			buy_button.pressed.disconnect(connection.callable)
		buy_button.pressed.connect(show_purchase_confirm.bind(upgrade_index))
		return true

func show_poor_label() -> void:
	buy_button.visible = false
	poor_label.visible = true

func _on_back_button_pressed() -> void:
	back.emit()
	upgrades_container.save_upgrades()
	contents_vbox.visible = false
