extends PickUp

@export var scale_increase : float = 5.0
@export var duration : float = 15.0

func apply_effect(target : Node2D) -> void:
	if target is Player:
		target.pickup_scale *= scale_increase
		await get_tree().create_timer(duration).timeout
		target.pickup_scale *= scale_increase
	super.apply_effect(target)
