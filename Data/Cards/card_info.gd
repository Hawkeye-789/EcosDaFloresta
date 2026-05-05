extends Resource
class_name CardInfo

@export var name : String
@export var image : Texture2D
@export var appear_weight : float = 1
@export_multiline var description : String

func effect() -> void:
	assert(false, "Subclasse de buffInfo deve fazer override em effect. Ocorreu em " + name)
