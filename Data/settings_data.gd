extends Resource
class_name SettingsData

@export var screen_mode_index : int = 0
@export var resolution_index : int = 0
@export_range(0.0, 1.0, 0.01) var master_volume : float = 0.8
@export_range(0.0, 1.0, 0.01) var music_volume : float = 0.8
@export_range(0.0, 1.0, 0.01) var sfx_volume : float = 0.8
@export var input_map : Dictionary

var res : Array[Vector2i] = [
	Vector2i(1280, 720),
	Vector2i(1440, 810),
	Vector2i(1920, 1080),
]

var _input_actions : Array[String]= [
	"ui_up",
	"ui_down",
	"ui_left",
	"ui_right",
	"ui_accept",
	"ui_cancel",	
	"menu",
]

func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(master_volume))
	AudioServer.set_bus_volume_db(1, linear_to_db(music_volume))
	AudioServer.set_bus_volume_db(2, linear_to_db(sfx_volume))

func apply_video_settings() -> void:
	var resolution : Vector2
	match screen_mode_index:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		4:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
	match resolution_index:
		0:
			resolution = res[0]
		2:
			resolution = res[1]
		4:
			resolution = res[2]
	if !(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN):
		_set_window_size(resolution)

func _set_window_size(resolution : Vector2i) -> void:
	DisplayServer.window_set_size(resolution)
	var screen_size := DisplayServer.screen_get_size()
	@warning_ignore("integer_division")
	var window_pos : Vector2i = screen_size/2 - resolution/2
	DisplayServer.window_set_position(window_pos)

func apply_control_settings() -> void:
	for action : String in input_map.keys():
		InputMap.action_erase_events(action)
		for event : InputEvent in input_map[action]:
			InputMap.action_add_event(action, event)

func update_controls() -> void:
	input_map.clear()
	for action in _input_actions:
		input_map[action] = InputMap.action_get_events(action)

func apply_settings() -> void:
	apply_audio_settings()
	apply_video_settings()
	apply_control_settings()
