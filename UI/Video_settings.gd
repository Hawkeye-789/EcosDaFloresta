extends Menu

var resolution : Vector2i

@onready var mode_button: OptionButton = $MarginContainer/VBoxContainer/ModeContainer/OptionButton
@onready var res_button: OptionButton = $MarginContainer/VBoxContainer/ResolutionContainer/OptionButton
@onready var back_button: Button = $MarginContainer/VBoxContainer/BackButton

func _on_window_mode_item_selected(index: int) -> void:
	match index:
		0:
			_set_window_size()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			_set_window_size()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		4:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)

	SaveManager.settings_data.screen_mode_index = index


func _on_resolution_item_selected(index: int) -> void:
	var res : Array[Vector2i] = SaveManager.settings_data.res
	match index:
		0:
			resolution = res[0]
		2:
			resolution = res[1]
		4:
			resolution = res[2]

	SaveManager.settings_data.resolution_index = index

	if !(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		_set_window_size()

func _apply_saved_settings() -> void:
	var s : SettingsData = SaveManager.settings_data

	if s.screen_mode_index != null:
		mode_button.select(s.screen_mode_index)
		_on_window_mode_item_selected(s.screen_mode_index)

	if s.resolution_index != null:
		res_button.select(s.resolution_index)
		_on_resolution_item_selected(s.resolution_index)

func _set_window_size() -> void:
	get_window().set_size(resolution)
	get_window().move_to_center()

func _ready() -> void:
	if back_button:
		back_button.pressed.connect(go_back)
	_apply_saved_settings()

func go_back() -> void:
	SaveManager.save_settings()
	back.emit()
