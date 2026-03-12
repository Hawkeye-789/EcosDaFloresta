extends Node2D
class_name Attack

enum AttackMode { Blow = 0, ProjectileSpawn = 1}
@export var mode : AttackMode = 0
@export var cooldown : float = 1
@export_group("Blow Mode")
@export var hitbox : Hitbox
@export_group("Projectile Mode")
@export var projectile_scene : Resource
@export var amount : int = 1
@export var spawn_delay : float = 0.1

@onready var cooldown_timer : Timer = $CooldownTimer

func _ready() -> void:
	cooldown_timer.wait_time = cooldown
	restart_cooldown()

func restart_cooldown() -> void:
	cooldown_timer.start()

func _on_cooldown_timer_timeout() -> void:
	_execute()

func _execute() -> void:
	pass
