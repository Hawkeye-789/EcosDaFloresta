extends Menu

func _on_yes_button_pressed() -> void:
	SaveManager.reset_save()

func _on_no_button_pressed() -> void:
	back.emit()
