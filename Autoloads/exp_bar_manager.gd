extends Node

var exp_bar : TextureProgressBar

func update_exp_bar_thresholds(new_min : float, new_max : float) -> void:
	if exp_bar:
		exp_bar.min_value = new_min
		exp_bar.max_value = new_max
	else:
		push_error("Falha de acesso à ExpBar!!")

func update_exp_bar_value(new_value : float) -> void:
	if exp_bar:
		exp_bar.value = new_value
	else:
		push_error("Falha de acesso à ExpBar!!")

func set_exp_bar(new_exp_bar : TextureProgressBar) -> void:
	exp_bar = new_exp_bar
