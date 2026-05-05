extends Resource
class_name PlayerInfo

@export var speed_multiplier : float = 1
@export var damage_multiplier : float = 1
@export var range_multiplier : float = 1
@export var exp_multiplier : float = 1

@export var exp_thresholds : Array[int]

var current_exp : float = 0
var current_level : int = 1

signal speed_changed
signal damage_changed
signal range_changed

func set_speed_multiplier(value : float) -> void:
	speed_multiplier = value
	speed_changed.emit()

func add_speed_multiplier(value: float) -> void:
	speed_multiplier += value
	speed_changed.emit()

func get_speed_multiplier() -> float:
	return speed_multiplier

func set_damage_multiplier(multiplier : float) -> void:
	damage_multiplier = multiplier
	damage_changed.emit()

func add_damage_multiplier(value: float) -> void:
	damage_multiplier += value
	damage_changed.emit()

func get_damage_multiplier() -> float:
	return damage_multiplier

func set_range_multiplier(multiplier : float) -> void:
	range_multiplier = multiplier
	range_changed.emit()

func add_range_multiplier(value: float) -> void:
	range_multiplier += value
	range_changed.emit()

func get_range_multiplier() -> float:
	return range_multiplier

func set_exp_multiplier(multiplier : float) -> void:
	exp_multiplier = multiplier

func add_exp_multiplier(value: float) -> void:
	exp_multiplier += value

func get_exp_multiplier() -> float:
	return exp_multiplier

func add_exp(value : float) -> void:
	current_exp += value * exp_multiplier
	ExpBarManager.update_exp_bar_value(current_exp)
	if current_exp > exp_thresholds[current_level - 1]:
		level_up()

func initialize_exp_bar() -> void:
	ExpBarManager.update_exp_bar_thresholds(0, exp_thresholds[0])

func level_up() -> void:
	current_level += 1
	ExpBarManager.update_exp_bar_thresholds(exp_thresholds[current_level-2], exp_thresholds[current_level-1])
	#print(exp_thresholds[current_level-2], " ", exp_thresholds[current_level-1], " Atual: ", current_exp)
	print("Cheguei no nível ", current_level, "!")
