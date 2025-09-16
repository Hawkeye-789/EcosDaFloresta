extends Control

var exp_bar : TextureProgressBar

func update_exp_bar_thresholds(new_min : float, new_max : float) -> void:
	exp_bar.min_value = new_min
	exp_bar.max_value = new_max

func update_exp_bar_value(new_value : float) -> void:
	exp_bar.value = new_value

func set_exp_bar(new_exp_bar : TextureProgressBar) -> void:
	exp_bar = new_exp_bar
