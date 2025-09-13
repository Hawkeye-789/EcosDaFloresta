extends CharacterBody2D
class_name Player

@export var move_speed : float

func _physics_process(_delta: float) -> void:
	var dir_x : int = int(Input.get_axis("left", "right"))
	var dir_y : int = int(Input.get_axis("up", "down"))
	velocity = Vector2(dir_x, dir_y).normalized() * move_speed
	move_and_slide()

func _on_pick_up_collector_area_entered(area: Area2D) -> void:
	var pick_up : PickUp = area.get_parent()
	pick_up.set_player(self)

func get_exp(value : int) -> void:
	print("Got ", value, " exp!")
