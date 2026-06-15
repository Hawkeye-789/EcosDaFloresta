extends Node2D
class_name DamageNumber

@export var enemy_damage_color : Color
@export var player_damage_color : Color
@export var heal_color : Color
@export var label : Label
@onready var anim : AnimationPlayer = $Label/Anim

enum DamageType {player, enemy, heal}

func start(damage_value : int, type : DamageType) -> void:
	match type:
		DamageType.player:
			modulate = player_damage_color
		DamageType.enemy:
			modulate = enemy_damage_color
		DamageType.heal:
			modulate = heal_color
	label.text = str(damage_value)
	anim.play("Start")
