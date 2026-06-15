@tool
extends EditorScript

const ROOT_FOLDER := "res://Data/Cards/Weapons/WeaponCards/Buffs"


func _run():

	var root := DirAccess.open(ROOT_FOLDER)

	root.list_dir_begin()

	var folder := root.get_next()

	while folder != "":

		if root.current_is_dir():
			process_weapon_folder(
				ROOT_FOLDER.path_join(folder)
			)

		folder = root.get_next()

	root.list_dir_end()

	EditorInterface.get_resource_filesystem().scan()

	print("Cartas atualizadas.")


func process_weapon_folder(folder_path:String):

	var dir := DirAccess.open(folder_path)

	if dir == null:
		return

	dir.list_dir_begin()

	var file := dir.get_next()
	var json_path := ""

	while file != "":

		if file.ends_with(".json"):
			json_path = folder_path.path_join(file)
			break

		file = dir.get_next()

	dir.list_dir_end()

	if json_path.is_empty():
		print("Sem json:", folder_path)
		return

	generate_cards(folder_path, json_path)


func generate_cards(folder_path:String, json_path:String):

	delete_old_cards(folder_path)

	var file := FileAccess.open(json_path, FileAccess.READ)

	if file == null:
		return

	var data = JSON.parse_string(file.get_as_text())

	if data == null:
		push_error("JSON inválido: " + json_path)
		return

	var weapon_name = data.get("weapon_name", folder_path.get_file())
	var upgrades = data.get("upgrades", {})

	for level in upgrades:

		var card := WeaponBuffCardInfo.new()

		card.name = "%s %s" % [
			weapon_name,
			level.capitalize()
		]

		card.buff_dictionary.assign(upgrades[level])

		var save_name := "%s_%s.tres" % [
			weapon_name.to_snake_case(),
			level
		]

		var save_path := folder_path.path_join(save_name)
	
	
		if ResourceLoader.exists(save_path):
			var old = ResourceLoader.load(save_path)

			if old:
				old.take_over_path("")
		
		var result := ResourceSaver.save(
				card,
				save_path,
				ResourceSaver.FLAG_CHANGE_PATH
			)

		if result != OK:
			push_error("Falha ao salvar " + save_path)
		else:
			print("Gerado:", save_path)

func delete_old_cards(folder_path:String):
	var dir := DirAccess.open(folder_path)
	if dir == null:
		return

	dir.list_dir_begin()

	var file := dir.get_next()

	while file != "":

		if (
			file.ends_with(".tres")
			and not file.ends_with(".json")
		):

			var full_path := folder_path.path_join(file)

			var result := DirAccess.remove_absolute(full_path)

			if result == OK:
				print("Removido:", full_path)

		file = dir.get_next()
	dir.list_dir_end()
