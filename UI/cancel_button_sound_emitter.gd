extends Button

func _ready() -> void:
	pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	AudioManager.play_song("ButtonCancel")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if is_visible_in_tree():
			pressed.emit()
			get_viewport().set_input_as_handled()
