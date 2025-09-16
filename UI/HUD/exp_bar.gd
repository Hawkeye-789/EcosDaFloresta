extends Control

@export var exp_bar : TextureProgressBar
@export var max_value_label : Label
@export var current_value_label : Label


func _ready() -> void:
	ExpBarManager.set_exp_bar(exp_bar)

func _on_texture_progress_bar_changed() -> void:
	max_value_label.text = str(int(exp_bar.max_value))

func _on_texture_progress_bar_value_changed(value: float) -> void:
	current_value_label.text = str(int(exp_bar.value))
