extends Node
class_name HealthManager

@export var max_health : float
var health : float

signal took_damage
signal died

func _ready() -> void:
	health = max_health

func still_alive() -> bool:
	return !is_zero_approx(health)

func take_damage(amount : float) -> void:
	health -= amount
	took_damage.emit()
	if !still_alive():
		died.emit()
