extends PickUp

@export var textures : Array[Texture]
@export var min_heal_value : float
@export var max_heal_value : float

var heal_value : float = 0.0

func _ready() -> void:
	heal_value = randf_range(min_heal_value, max_heal_value)
	sprite.texture = textures.pick_random()

func apply_effect(target : Node2D) -> void:
	if target is Player:
		target.health_man.heal(heal_value)
