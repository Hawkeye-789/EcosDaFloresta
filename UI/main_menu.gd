extends Control
class_name Main_Menu

@export var settings_menu : Control = null
@export var buttons_container : MarginContainer
@export var back_to_title_menu : MarginContainer
@export var world : Node2D

var open : bool = false
var last_button_pressed : Button

signal return_to_menu

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	last_button_pressed = buttons_container.get_child(0).get_child(0)

func open_menu() -> void:
	open = true
	world.process_mode = Node.PROCESS_MODE_DISABLED
	self.visible = true
	show_buttons()

func open_settings() -> void:
	last_button_pressed = buttons_container.get_child(0).get_child(1)
	buttons_container.visible = false
	settings_menu.visible = true
	settings_menu.setup_buttons()
	settings_menu.give_focus()

func open_back_to_title() -> void:
	buttons_container.visible = false
	last_button_pressed = buttons_container.get_child(0).get_child(2)
	back_to_title_menu.visible = true
	var no_button : Button = back_to_title_menu.find_child("NoButton")
	no_button.grab_focus()

func close_back_to_title() -> void:
	back_to_title_menu.visible = false
	show_buttons()

func go_back_to_title() -> void:
	return_to_menu.emit()

func show_buttons() -> void:
	buttons_container.visible = true
	last_button_pressed.grab_focus()

func close_settings() -> void:
	settings_menu.setup_buttons()
	settings_menu.visible = false
	show_buttons()

func close_menu() -> void:
	last_button_pressed = buttons_container.get_child(0).get_child(0)
	open = false
	world.process_mode = Node.PROCESS_MODE_INHERIT
	self.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("menu") and !open:
		open_menu()


func _on_settings_menu_back() -> void:
	pass # Replace with function body.
