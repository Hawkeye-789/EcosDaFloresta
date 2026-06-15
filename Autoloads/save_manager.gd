extends Node

var save_data: SaveData
var settings_data: SettingsData

const SAVE_PATH := "user://ecos-da-floresta--save.tres"
const SETTINGS_PATH := "user://ecos-da-floresta--settings.tres"

func _ready() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		save_data = SaveData.new()
		settings_data = SettingsData.new()
		save()
		save_settings()
	else:
		load_save()
		load_settings()

func _exit_tree() -> void:
	save()
	save_settings()

func load_save() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		save_data = ResourceLoader.load(SAVE_PATH) as SaveData
		if save_data == null:
			push_error("Erro ao carregar save.")
			save_data = SaveData.new()
	else:
		save_data = SaveData.new()

func save() -> void:
	if save_data == null:
		save_data = SaveData.new()
	var result := ResourceSaver.save(save_data, SAVE_PATH)
	if result != OK:
		push_error("Erro ao salvar: %s" % result)

func load_settings() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		settings_data = ResourceLoader.load(SETTINGS_PATH) as SettingsData
		if settings_data == null:
			push_error("Erro ao carregar settings.")
			settings_data = SettingsData.new()
	else:
		settings_data = SettingsData.new()
	settings_data.apply_settings()

func reset_save() -> void:
	save_data = SaveData.new()
	save()
	get_tree().reload_current_scene()

func save_settings() -> void:
	if settings_data == null:
		settings_data = SettingsData.new()
	else:
		settings_data.update_controls()
	var result := ResourceSaver.save(settings_data, SETTINGS_PATH)
	if result != OK:
		push_error("Erro ao salvar configurações: %s" % result)
