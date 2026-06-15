extends Control

@export var title_menu : MarginContainer
@export var shop : UpgradeShop
@export var settings_menu : Control
@export var quit_menu : MarginContainer

signal game_start
signal quit_game

func _ready() -> void:
	var focus_button : Button = find_child("PlayButton")
	focus_button.grab_focus()

func return_menu_from_game() -> void:
	visible = true
	title_menu.visible = true

func show_quit_menu() -> void:
	title_menu.visible = false
	quit_menu.visible = true
	var focus_button : Button = quit_menu.find_child("NoButton")
	focus_button.grab_focus()
 
func hide_quit() -> void:
	quit_menu.visible = false
	title_menu.visible = true
	var focus_button : Button = title_menu.find_child("QuitButton")
	focus_button.grab_focus()

func quit() -> void:
	quit_game.emit()

func show_settings() -> void:
	settings_menu.visible = true
	title_menu.visible = false
	var focus_button : Button = settings_menu.find_child("BackButton")
	focus_button.grab_focus()

func hide_settings() -> void:
	settings_menu.visible = false
	title_menu.visible = true
	var focus_button : Button = title_menu.find_child("SettingsButton")
	focus_button.grab_focus()

func show_shop() -> void:
	title_menu.visible = false
	shop.visible = true
	var focus_button : Button = shop.find_child("BackButton")
	focus_button.grab_focus()

func hide_shop() -> void:
	title_menu.visible = true
	shop.visible = false
	var focus_button : Button = title_menu.find_child("ShopButton")
	focus_button.grab_focus()

func start_game() -> void:
	game_start.emit()
