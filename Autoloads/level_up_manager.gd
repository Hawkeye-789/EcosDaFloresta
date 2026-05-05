extends Node

@export var exp_data : ExpData

var current_level : int = 0:
	set(level):
		if current_exp < exp_data.level_thresholds[current_level]:
			current_exp = exp_data.level_thresholds[current_level]
		if current_level < level:
			current_level = level
			level_up()
var current_exp : float = 0:
	set(exp):
		current_exp = exp
		if current_exp > exp_data.level_thresholds[current_level]:
			current_level += 1
		ExpBarManager.update_exp_bar_value(current_exp)

var level_up_screen : LevelUpScreen
var game_scene : Game

func set_level_up_screen(screen : LevelUpScreen) -> void:
	level_up_screen = screen
	connect_game_and_screen()

func connect_game_and_screen() -> void:
	if level_up_screen and game_scene:
		level_up_screen.started.connect(game_scene.pause)
		level_up_screen.finished.connect(game_scene.resume)

func set_game_scene(game : Game) -> void:
	game_scene = game
	connect_game_and_screen()

func set_exp(exp_value : float) -> void:
	current_exp = exp_value

func add_exp(exp_value : float) -> void:
	current_exp += exp_value

func _ready() -> void:
	await get_tree().create_timer(2.0).timeout
	current_level = 1

func level_up() -> void:
	if level_up_screen:
		if current_level == 1:
			level_up_screen.setup_weapon_select()
		else:
			level_up_screen.setup_skill_select()
		ExpBarManager.update_exp_bar_thresholds(exp_data.level_thresholds[current_level - 1], exp_data.level_thresholds[current_level])
	else:
		push_error("Level Up Screen não presente em Level Up Manager!!")
