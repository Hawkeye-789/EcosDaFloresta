extends Node

var health_bar : TextureProgressBar

func update_health_bar_max(new_max : float) -> void:
	if health_bar:
		health_bar.max_value = new_max
	else:
		push_error("Falha de acesso à HealthBar!!")

func update_health_bar_value(new_value : float) -> void:
	if health_bar:
		health_bar.value = new_value
	else:
		push_error("Falha de acesso à HealthBar!!")

func set_health_bar(new_health_bar : TextureProgressBar) -> void:
	health_bar = new_health_bar
