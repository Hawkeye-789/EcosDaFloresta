extends Effect

@export var damage : float = 1
@export_range(0.0, 1.0, 0.01) var slowness : float = 0.8
@export var duration : float

func apply_effect(target : CharacterBody2D) -> void:
	if target is Enemy:
		target.poison_effect(duration, damage, slowness)
