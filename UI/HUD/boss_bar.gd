extends MarginContainer
class_name BossBar

@export var name_label : Label
@export var bar : TextureProgressBar

func _ready() -> void:
	BossBarManager.set_boss_bar(self)

func set_boss_name(boss_name : String) -> void:
	name_label.text = boss_name

func set_max_health_value(value : float) -> void:
	bar.max_value = value
	bar.value = value

func reduce_health(amount : float) -> void:
	bar.value -= amount

func clear() -> void:
	name_label.text = ""
	bar.value = bar.min_value
