extends Node

@onready var damage_number_scene : PackedScene = preload("res://Utilities/Components/damage_number_label.tscn")

const position_base_offset : Vector2 = Vector2(0, -10)

func spawn_damage_number(damage_value : float, position : Vector2, damage_type : DamageNumber.DamageType) -> void:
	var damage_number_instance : DamageNumber = damage_number_scene.instantiate()
	var position_offset : Vector2 = position_base_offset + Vector2(randf_range(-5, 5), randf_range(-5, 5))
	damage_number_instance.position = position + position_offset
	get_tree().get_first_node_in_group("Game").call_deferred("add_child", damage_number_instance)
	damage_number_instance.call_deferred("start", damage_value, damage_type)
