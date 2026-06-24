extends Node

@export var exp_data : ExpData

var current_level : int = 0:
	set(level):
		if current_exp < exp_data.level_thresholds[current_level]:
			current_exp = exp_data.level_thresholds[current_level]
		var level_difference : int = level - current_level
		for i in range(level_difference):
			current_level += 1
			await level_up()
var current_exp : float = 0:
	set(exp):
		current_exp = exp
		var level_increase : int = 0
		for i : int in range(current_level, exp_data.level_thresholds.size()):
			if current_exp > exp_data.level_thresholds[i]:
				level_increase += 1
			else:
				break
		if level_increase > 0:
			current_level += level_increase
		ExpBarManager.update_exp_bar_value(current_exp)

var level_up_screen : LevelUpScreen

func _ready() -> void:
	await ExpBarManager.ready_to_work
	ExpBarManager.update_exp_bar_thresholds(0.0, exp_data.level_thresholds[1] + 1)

func set_level_up_screen(screen : LevelUpScreen) -> void:
	level_up_screen = screen

func set_exp(exp_value : float) -> void:
	current_exp = exp_value

func add_exp(exp_value : float) -> void:
	current_exp += exp_value

func reset() -> void:
	current_level = 0
	current_exp = 0

func level_up() -> void:
	print(current_level)
	if not level_up_screen:
		push_error("Level Up Screen não presente em Level Up Manager!!")
	else:
		if current_level == 1:
			level_up_screen.setup_weapon_select()
		else:
			AudioManager.play_song("PlayerLevelUp")
			level_up_screen.setup_skill_select()
			PlayerManager.increase_health_on_level_up()
		ExpBarManager.update_exp_bar_thresholds(exp_data.level_thresholds[current_level - 1], exp_data.level_thresholds[current_level] + 1)
		await level_up_screen.finished
		await get_tree().create_timer(0.1).timeout 
