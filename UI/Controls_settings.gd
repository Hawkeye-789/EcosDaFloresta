extends Menu

@export var buttons_containers: Array[Control]
@export var reset_button: Button
@export var back_button: Button

@export var input_button : PackedScene

var mapping: bool = false
var remapping_action : String
var remapping_button : Button = null
var previous_event: InputEvent = null
var previous_button: Button = null

var input_actions : Dictionary[String, String]= {
	"ui_up": "Cima",
	"ui_down": "Baixo",
	"ui_left": "Esquerda",
	"ui_right": "Direita",
	"ui_accept": "Confirmar",
	"ui_cancel": "Cancelar",
	"menu": "Menu",
}

var forbidden_keys : Array[Key]= [
	KEY_ESCAPE,
	KEY_ALT
]

func is_forbidden(event: InputEventKey) -> bool:
	for key in forbidden_keys:
		if key == event.keycode:
			return true
	return false


func _ready() -> void:
	_create_action_list()

func _create_action_list() -> void:
	var last_button: Button = null
	var created_buttons: Array[Button] = []
	
	# Remove botões antigos
	for container in buttons_containers:
		for button in container.get_children():
			if button is Button:
				if button.pressed.is_connected(remap_action):
					button.pressed.disconnect(remap_action)
			button.queue_free()
	
	# Cria lista de ações
	var keys := input_actions.keys()
	for i in range(keys.size()):
		var action : String = keys[i]
		var button: Button = input_button.instantiate()
		var action_label: Label = button.find_child("ActionLabel")
		var input_label: Label = button.find_child("InputLabel")
		
		action_label.text = str(input_actions[action])
		
		var events := InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" - Physical")
		else:
			input_label.text = ""
		
		buttons_containers[0 if i < 4 else 1].add_child(button)
		button.pressed.connect(remap_action.bind(button, action))
		
		last_button = button
		created_buttons.append(button)
	
	# Navegação por foco
	if last_button and reset_button:
		reset_button.focus_neighbor_top = last_button.get_path()
		last_button.focus_neighbor_bottom = reset_button.get_path()
	
	for i in range(0, created_buttons.size(), 2):
		if i + 1 < created_buttons.size():
			var left_button := created_buttons[i]
			var right_button := created_buttons[i + 1]
			
			left_button.focus_neighbor_right = right_button.get_path()
			left_button.focus_neighbor_left = right_button.get_path()
			right_button.focus_neighbor_left = left_button.get_path()
			right_button.focus_neighbor_right = left_button.get_path()
	
	if created_buttons.size() > 0 and back_button:
		created_buttons[0].focus_neighbor_top = back_button.get_path()
		back_button.focus_neighbor_bottom = created_buttons[0].get_path()
	
	if created_buttons.size() > 1 and back_button:
		created_buttons[1].focus_neighbor_top = back_button.get_path()


func remap_action(button : Button, action : String) -> void:
	if not mapping:
		AudioManager.play_song("ButtonAccept")
		mapping = true
		remapping_action = action
		remapping_button = button
		button.find_child("InputLabel").text = "[Pressione qualquer tecla]"

func _input(event: InputEvent) -> void:
	if mapping:
		if event is InputEventKey:
			if not is_forbidden(event):
				var events := InputMap.action_get_events(remapping_action)
				if events.size() > 0:
					previous_event = events[0]
				AudioManager.play_song("ButtonAccept")
				remap_input(remapping_action, event)
				update_labeling(remapping_button, event)
				
				mapping = false
				remapping_button = null
				
				accept_event()

func remap_input(action : String, event: InputEvent) -> void:
	var previous_action := find_action_by_event(event)
	if previous_action != "":
		if previous_action != action:
			for container in buttons_containers:
				for button in container.get_children():
					if button.find_child("ActionLabel").text == input_actions[previous_action]:
						previous_button = button
			InputMap.action_erase_events(previous_action)
			InputMap.action_add_event(previous_action, previous_event)
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, event)


func find_action_by_event(event: InputEvent) -> String:
	for action in input_actions:
		var events := InputMap.action_get_events(action)
		if events.size() > 0:
			if events[0].is_match(event):
				return action
	return ""

func update_labeling(button: Button, event: InputEvent) -> void:
	var event_string: String = event.as_text().trim_suffix(" - Physical")
	var previous_event_string: String
	if previous_event != null:
		previous_event_string = previous_event.as_text().trim_suffix(" - Physical")
	button.find_child("InputLabel").text = event_string
	if previous_button != null:
		previous_button.find_child("InputLabel").text = previous_event_string
		previous_button = null
		previous_event = null

func _on_reset_button_pressed() -> void:
	InputMap.load_from_project_settings()
	_create_action_list()

func go_back() -> void:
	SaveManager.save_settings()
	back.emit()
