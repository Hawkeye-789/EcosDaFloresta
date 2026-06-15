extends Node

var player : Player

signal player_connected

func set_player(new_player : Player) -> void:
	player = new_player
	player_connected.emit()

func get_player() -> Player:
	if player:
		return player
	else:
		push_error("Player não carregado em PlayerManager!")
		return null

func give_player_weapon(weapon : Weapon) -> void:
	if player:
		player.equip_weapon(weapon)
	else:
		push_error("Player não carregado em PlayerManager!")

func give_player_node_passive(passive_node : Node) -> void:
	if player:
		player.add_child(passive_node)
	else:
		push_error("Player não carregado em PlayerManager!")

func give_player_weapon_effect(effect : Effect) -> void:
	if player:
		if player.current_weapon:
			player.equip_weapon_effect(effect)
		else:
			push_error("Player tentou ganhar efeito sem nenhuma arma equipada!")

func change_player_property(property : String, value : float) -> void:
	if player:
		if property in player:
			player.set(property, player.get(property) + value)
		else:
			push_error("Propriedade " + property + " não encontrada em Player!")
	else:
			push_error("Player não carregado em PlayerManager!")

func increase_health_on_level_up() -> void:
	if player:
		var health_increase : float = player.health_increase_on_level_up * player.health_mult
		player.health += health_increase
		player.health_man.health += health_increase
		player.on_health_changed()
	else:
		push_error("Player não carregado em PlayerManager!")

func reset_player() -> void:
	if player:
		player.reset_multipliers()
	else:
		push_error("Player não carregado em PlayerManager!")
