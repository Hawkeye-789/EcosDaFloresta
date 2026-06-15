extends Effect

@export var explosion_scene : PackedScene
@export_range(0.0, 1.0, 0.01) var explosion_chance : float = 0.25

func apply_effect(target : CharacterBody2D) -> void:
	if randf() < explosion_chance:
		var explosion_instance : Node2D = explosion_scene.instantiate()
		if explosion_instance is Node2D:
			explosion_instance.position = target.position + (get_parent().position - target.position).normalized() * 20
			get_tree().get_first_node_in_group("Game").call_deferred("add_child", explosion_instance)
			AudioManager.play_song("Explosion")
