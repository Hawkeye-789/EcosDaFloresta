extends Node
class_name HealthManager

var max_health : float
var health : float

signal took_damage
signal died
signal healed

func set_max_health(amount : float) -> void:
	max_health = amount
	health = max_health

func still_alive() -> bool:
	return health > 0.0

func take_damage(amount : float) -> void:
	health -= amount
	took_damage.emit()
	if !still_alive():
		died.emit()

func heal(amount : float) -> void:
	health = clampf(health + amount, 0.0, max_health)
	healed.emit()
