extends Effect

@export var effect_duration : float = 4.0

func apply_effect(target : CharacterBody2D) -> void:
	if target is Enemy:
		if target.is_inside_tree() and is_instance_valid(target):
			target.sleep_effect(effect_duration)
