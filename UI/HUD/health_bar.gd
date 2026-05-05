extends Control

@export var health_bar : TextureProgressBar
@export var max_value_label : Label
@export var current_value_label : Label

@onready var base_length : float = health_bar.custom_minimum_size.x
var length_multiplier : float
var first_time : bool = true

func _ready() -> void:
	HealthBarManager.set_health_bar(health_bar)

func _on_texture_progress_bar_changed() -> void:
	if first_time:
		first_time = false
		length_multiplier = base_length / pow(health_bar.max_value, 1.0/3.0)
	else:
		health_bar.custom_minimum_size.x = pow(health_bar.max_value, 1.0/3.0) * length_multiplier
	max_value_label.text = str(int(health_bar.max_value))

func _on_texture_progress_bar_value_changed(value: float) -> void:
	current_value_label.text = str(int(health_bar.value))
