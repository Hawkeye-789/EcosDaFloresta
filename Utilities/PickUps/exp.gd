extends PickUp
class_name Exp

enum ExpValues { Small = 1, Medium = 5, Big = 20}
var exp_value : int

@export var textures : Array[Texture2D]

func apply_effect(_target: Node2D) -> void:
	super.apply_effect(_target)
	player.get_exp(exp_value)

func set_value(value : ExpValues) -> void:
	exp_value = value
	match exp_value:
		ExpValues.Small:
			sprite.texture = textures[0]
		ExpValues.Medium:
			sprite.texture = textures[1]
		ExpValues.Big:
			sprite.texture = textures[2]
		_:
			print("Erro. Valor não suportado por XP")
	
