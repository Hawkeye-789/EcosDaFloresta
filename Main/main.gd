extends Node

@export var title_screen : CanvasLayer
@export var test_title_screen : bool = false
@export var game_scene : PackedScene
@export var title_scene : PackedScene
@export var color_rect : ColorRect

var game : Game

func _ready() -> void:
	SaveManager.load_save()
	SaveManager.load_settings()
	CoinManager.set_coins(SaveManager.save_data.get_coins())
	var title_screen_instance := title_scene.instantiate()
	title_screen_instance.game_start.connect(start_game)
	title_screen_instance.quit_game.connect(quit_game)
	title_screen.add_child(title_screen_instance)
	await fade_in()
	if !test_title_screen:
		start_game()
	else:
		AudioManager.play_song("TitleMusic")

func start_game() -> void:
	game = game_scene.instantiate()
	AudioManager.stop("TitleMusic")
	await fade_out()
	add_child(game)
	game.ending_game.connect(end_game)
	game.restarting_game.connect(restart_game)
	title_screen.visible = false
	LevelUpManager.reset()
	game.start()
	await fade_in()

func fade_out() -> void:
	var tween := create_tween()
	await tween.tween_property(color_rect,"modulate", Color.WHITE, 0.8).finished

func fade_in() -> void:
	await get_tree().create_timer(1.0).timeout
	var tween := create_tween()
	await tween.tween_property(color_rect,"modulate", Color.TRANSPARENT, 0.8).finished

func end_game(go_to_title : bool) -> void:
	await fade_out()
	game.queue_free()
	if go_to_title:
		title_screen.visible = true
		await fade_in()
		AudioManager.play_song("TitleMusic")
		SaveManager.save()
	else:
		quit_game()

func restart_game() -> void:
	await fade_out()
	game.queue_free()
	SaveManager.save()
	start_game()

func quit_game() -> void:
	SaveManager.save()
	get_tree().quit()
