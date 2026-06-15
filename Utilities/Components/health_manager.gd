extends Node
class_name HealthManager

@export var parent : Node2D

var max_health : float
var health : float

signal took_damage(amount : float)
signal died
signal healed

func set_max_health(amount : float) -> void:
	max_health = amount
	health = max_health

func still_alive() -> bool:
	return health > 0.0

func take_damage(amount : float) -> void:
	health -= amount
	took_damage.emit(amount)
	DamageNumberManager.spawn_damage_number(amount, parent.position, DamageNumber.DamageType.player if parent is Player else DamageNumber.DamageType.enemy)
	if !still_alive():
		died.emit()

func heal(amount : float) -> void:
	health = clampf(health + amount, 0.0, max_health)
	healed.emit()
	DamageNumberManager.spawn_damage_number(amount, parent.position, DamageNumber.DamageType.heal)
