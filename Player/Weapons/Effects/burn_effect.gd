extends Effect

@export var duration : float = 4.0
@export var burn_damage : float = 15.0

func apply_effect(target : CharacterBody2D) -> void:
	if target is Enemy:
		target.burn_effect(duration, burn_damage)
