extends PickUp

@export var textures : Array[Texture]
@export var min_heal_value_perc : float = 0.2
@export var max_heal_value_perc : float = 0.4

var heal_percentage : float = 0.0

func _ready() -> void:
	heal_percentage = randf_range(min_heal_value_perc, max_heal_value_perc)
	if !textures.is_empty():
		sprite.texture = textures.pick_random()

func apply_effect(target : Node2D) -> void:
	if target is Player:
		AudioManager.play_song("FoodGet")
		var heal_value : float = target.health * heal_percentage
		target.health_man.heal(heal_value)
	queue_free()
