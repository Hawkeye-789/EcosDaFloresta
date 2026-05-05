extends Node

var player : Player

func set_player(new_player : Player) -> void:
	player = new_player

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
			player.set(property, player.get(property) * (1.0 + value))
		else:
			push_error("Propriedade " + property + " não encontrada em Player!")
	else:
			push_error("Player não carregado em PlayerManager!")
