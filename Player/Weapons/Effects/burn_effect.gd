extends Effect

@export var duration : float
@export var burn_damage : float

func apply_effect(target : CharacterBody2D) -> void:
	if target is Enemy:
		target.burn_effect(duration, burn_damage)
