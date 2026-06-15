extends Node2D
class_name Game

@export var blur : ColorRect
@export var hud_layer : CanvasLayer
@export var level_up_screen : LevelUpScreen
@export var spawner : SpawnerPath
@export var game_over_menu : Control
@export var victory_screen : Control

var previous_coin_count : int = 0

signal ending_game(title : bool)
signal restarting_game

func _ready() -> void:
	visible = false
	spawner.spawn_enemy.connect(spawn_enemy)
	previous_coin_count = CoinManager.coins
	CoinManager.set_coins(0)
	level_up_screen.weapon_chosen.connect(_on_level_up_screen_weapon_chosen, ConnectFlags.CONNECT_ONE_SHOT)
	await get_tree().create_timer(2.0).timeout
	get_first_level_up()

func pause() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	blur.visible = true

func resume() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	blur.visible = false 

func start() -> void:
	AudioManager.play_song("LevelMusic")
	hud_layer.visible = true
	visible = true

func spawn_enemy(enemy : Enemy) -> void:
	call_deferred("add_child", enemy)

func get_first_level_up() -> void:
	LevelUpManager.current_level = 1

func _on_return_to_menu() -> void:
	end_game(true)

func handle_game_results() -> void:
	CoinManager.set_coins(CoinManager.coins + previous_coin_count)
	SaveManager.save_data.set_coins(CoinManager.coins)
	SaveManager.save()

func end_game(go_to_title : bool) -> void:
	handle_game_results()
	ending_game.emit(go_to_title)

func restart_game() -> void:
	handle_game_results()
	restarting_game.emit()

func quit_game() -> void:
	end_game(false)

func game_over() -> void:
	game_over_menu.show_up()

func _on_spawner_container_finished() -> void:
	finish_game()

func finish_game() -> void:
	victory_screen.show_up()
	pause()

func _on_level_up_screen_weapon_chosen(weapon_info: WeaponCardInfo) -> void:
	victory_screen.set_chosen_weapon(weapon_info.legend_info)
	game_over_menu.set_legend(weapon_info.legend_info)
