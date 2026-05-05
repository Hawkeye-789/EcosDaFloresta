extends Control
class_name LevelUpScreen

@export var hbox : HBoxContainer
@export_range(0.0, 1.0, 0.01) var weapon_skill_chance : float = 1.0
var buff_cards : Array[BuffCard]

var weapon_cards : Array[WeaponCardInfo]
var weapon_buff_cards : Array[WeaponBuffCardInfo]
var passive_cards : Array[PassiveCardInfo]


var current_weapon : WeaponCardInfo
var weapon_level : int = 0

signal started
signal finished

func setup_cards() -> void:
	var card_containers := hbox.get_children()
	for container in card_containers:
		if container is Control:
			var child := container.get_child(0)
			if child is BuffCard:
				child.chosen.connect(card_was_chosen)
				buff_cards.append(child)

func _ready() -> void:
	visible = false
	setup_cards()
	load_weapon_cards()
	LevelUpManager.set_level_up_screen(self)

func load_weapon_cards():
	var path := "res://Data/Cards/Weapons/WeaponCards"
	var dir = DirAccess.open(path)
	if dir == null:
		push_error("Erro ao abrir pasta: " + path)
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue
		if not file_name.ends_with(".tres"):
			file_name = dir.get_next()
			continue
		var full_path = path + "/" + file_name
		var res = load(full_path)
		if res is WeaponCardInfo:
			weapon_cards.append(res)
		else:
			push_warning("Arquivo não é WeaponCardInfo: " + full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

func load_weapon_buffs_for(card: WeaponCardInfo) -> void:
	var base_name = card.resource_path.get_file().get_basename()
	var root_path := "res://Data/Cards/Weapons/WeaponBuffCards"
	_load_buffs_recursive(root_path, base_name)

func _load_buffs_recursive(path: String, base_name: String):
	var dir = DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		var full_path = path + "/" + file_name
		if dir.current_is_dir():
			if file_name != "." and file_name != "..":
				_load_buffs_recursive(full_path, base_name)
		else:
			if file_name.ends_with(".tres"):
				var file_base_name = file_name.get_basename()
				if file_base_name.begins_with(base_name + "_lvl"):
					var res = load(full_path)
					if res is WeaponBuffCardInfo:
						weapon_buff_cards.append(res)
		file_name = dir.get_next()
	dir.list_dir_end()

func load_passive_cards() -> void:
	var path : String = "res://Data/Cards/Passives"
	var dir : DirAccess = DirAccess.open(path)
	if dir == null:
		push_error("Erro ao abrir pasta: " + path)
		return
	dir.list_dir_begin()
	var file_name : String = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue
		if not file_name.ends_with(".tres"):
			file_name = dir.get_next()
			continue
		var full_path  : String = path + "/" + file_name
		var res : Resource = load(full_path)
		if res is PassiveCardInfo:
			passive_cards.append(res)
		else:
			push_warning("Arquivo não é PassiveCardInfo: " + full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

func fill_in_cards(cards : Array) -> void:
	visible = true
	started.emit()
	for i in range(buff_cards.size()):
		buff_cards[i].fill_in(cards[i])

func setup_weapon_select() -> void:
	assert(buff_cards.size() == weapon_cards.size(), "Número de cartas no menu não bate com número de cartas de armas que existem! Respectivemente "
		 					+ str(buff_cards.size()) + " e " + str(weapon_cards.size()))
	fill_in_cards(weapon_cards)

func card_was_chosen(_card : BuffCard, buff : CardInfo) -> void:
	finished.emit()
	visible = false
	if buff is WeaponBuffCardInfo:
		print("Weapon buff: ", buff.name)
		weapon_buff_cards.remove_at(weapon_buff_cards.find(buff))
		weapon_level += 1
		buff.effect()
	elif buff is WeaponCardInfo:
		print("Weapon: ", buff.name)
		current_weapon = buff
		weapon_level = 1
		load_weapon_buffs_for(buff)
		load_passive_cards()
		buff.effect()
	elif buff is PassiveCardInfo:
		print("Passive: ", buff.name)
		buff.effect()
		if !(buff.can_be_picked()):
			passive_cards.remove_at(passive_cards.find(buff))

func get_next_weapon_buff() -> WeaponBuffCardInfo:
	if current_weapon == null:
		return null
	var base_name = current_weapon.resource_path.get_file().get_basename()
	var next_level = weapon_level + 1
	var target_name = base_name + "_lvl" + str(next_level)
	for i in range(weapon_buff_cards.size()):
		var buff_name = weapon_buff_cards[i].resource_path.get_file().get_basename()
		if buff_name == target_name:
			return weapon_buff_cards[i]
	return null

func setup_skill_select() -> void:
	var selected_cards : Array[CardInfo]
	if randf() < weapon_skill_chance and not weapon_buff_cards.is_empty():
		selected_cards.append(get_next_weapon_buff())
		selected_cards.append_array(pick_multiple_weighted(passive_cards, buff_cards.size() - 1))
	else:
		selected_cards.append_array(pick_multiple_weighted(passive_cards, buff_cards.size()))
	fill_in_cards(selected_cards)

func pick_weighted(cards: Array[PassiveCardInfo]) -> PassiveCardInfo:
	var total_weight := 0.0
	for c in cards:
		total_weight += c.appear_weight
	var r = randf() * total_weight
	var cumulative := 0.0
	for c in cards:
		cumulative += c.appear_weight
		if r <= cumulative:
			return c
	return cards.back()

func pick_multiple_weighted(cards: Array[PassiveCardInfo], count: int) -> Array[PassiveCardInfo]:
	var pool = cards.duplicate()
	var result : Array[PassiveCardInfo] = []
	for i in range(count):
		if pool.is_empty():
			break
		var chosen = pick_weighted(pool)
		result.append(chosen)
		pool.erase(chosen)
	return result
