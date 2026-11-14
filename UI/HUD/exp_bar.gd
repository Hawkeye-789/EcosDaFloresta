extends Control

@export var bar : TextureProgressBar
@export var max_value_label : Label
@export var current_value_label : Label

func _ready() -> void:
	ExpBarManager.set_exp_bar(bar)

func _on_texture_progress_bar_changed() -> void:
	max_value_label.text = str(int(bar.max_value))

func _on_texture_progress_bar_value_changed(value: float) -> void:
	current_value_label.text = str(int(bar.value))
