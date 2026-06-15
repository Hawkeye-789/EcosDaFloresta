extends PickUp

@export var scale_increase : float = 5.0
@export var duration : float = 1.0

func apply_effect(target : Node2D) -> void:
	if target is Player:
		AudioManager.play_song("PickupGet")
		collision_area.collision_mask = 0
		visible = false
		target.pickup_scale *= scale_increase
		await get_tree().create_timer(duration).timeout
		target.pickup_scale /= scale_increase
		queue_free()
