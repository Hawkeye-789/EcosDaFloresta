extends Node

var boss_bar : BossBar

func set_boss_bar_max(new_max : float) -> void:
	if boss_bar:
		boss_bar.set_max_health_value(new_max)
	else:
		push_error("Falha de acesso à BossBar!!")

func set_boss_name(boss_name : String) -> void:
	if boss_bar:
		boss_bar.set_boss_name(boss_name)
	else:
		push_error("Falha de acesso à BossBar!!")

func show_boss_bar() -> void:
	if boss_bar:
		boss_bar.visible = true
	else:
		push_error("Falha de acesso à BossBar!!")

func hide_boss_bar() -> void:
	if boss_bar:
		boss_bar.visible = false
	else:
		push_error("Falha de acesso à BossBar!!")

func decrease_boss_bar_value(decrease_value : float) -> void:
	if boss_bar:
		boss_bar.reduce_health(decrease_value)
	else:
		push_error("Falha de acesso à BossBar!!")

func clear_boss_bar() -> void:
	boss_bar.clear()

func set_boss_bar(new_boss_bar : BossBar) -> void:
	boss_bar = new_boss_bar
