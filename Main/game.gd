extends Node2D
class_name Game
@export var blur : ColorRect

func _ready() -> void:
	LevelUpManager.set_game_scene(self)

func pause() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	blur.visible = true

func resume() -> void:
	set_deferred("process_mode", Node.PROCESS_MODE_INHERIT)
	blur.visible = false
