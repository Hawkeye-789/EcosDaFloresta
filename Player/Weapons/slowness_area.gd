extends Area2D

@export_range(0.0, 1.0, 0.01) var slow_factor : float

func _on_body_entered(body: Node2D) -> void:
	if body is Enemy:
		body.move_speed *= slow_factor

func _on_body_exited(body: Node2D) -> void:
	if body is Enemy:
		body.move_speed /= slow_factor
