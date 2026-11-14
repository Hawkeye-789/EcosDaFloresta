extends Control

@export var bar : TextureProgressBar
@export var max_value_label : Label
@export var current_value_label : Label

@onready var base_length : float = bar.custom_minimum_size.x
var length_multiplier : float
var first_time : bool = true

func _ready() -> void:
	HealthBarManager.set_health_bar(bar)

func _on_texture_progress_bar_changed() -> void:
	if first_time:
		first_time = false
		length_multiplier = base_length / pow(bar.max_value, 1.0/3.0)
	else:
		bar.custom_minimum_size.x = pow(bar.max_value, 1.0/3.0) * length_multiplier
	max_value_label.text = str(int(bar.max_value))
	current_value_label.text = str(int(bar.value))

func _on_texture_progress_bar_value_changed(value: float) -> void:
	current_value_label.text = str(int(bar.value))
