extends PickUp
class_name Exp

enum ExpValues { Small = 1, Medium = 10, Big = 20}
var exp_value : float

@export var textures : Array[Texture2D]

func apply_effect(target: Node2D) -> void:
	super.apply_effect(target)
	if target is Player:
		target.get_exp(exp_value)

func set_value(value : float) -> void:
	exp_value = value
	if exp_value >= ExpValues.Small:
		sprite.texture = textures[0]
	if exp_value >= ExpValues.Medium:
		sprite.texture = textures[1]
	if exp_value >= ExpValues.Big:
		sprite.texture = textures[2]
	
