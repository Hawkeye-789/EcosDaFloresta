extends CharacterBody2D
class_name Player

@export var base_speed : float
@export var invincibility_time : float
@export var spawner_remote_transform : RemoteTransform2D
@export var pickup_collector : Area2D
@export var health : float:
	set(value):
		health = value
		if health_man:
			health_man.max_health = value
		if HealthBarManager.health_bar:
			HealthBarManager.update_health_bar_max(value)
@export var health_increase_on_level_up : int = 40
@export var health_man : HealthManager
@export var hurtbox : Area2D
@export var pickup_scale : float = 200.0:
	set(value):
		pickup_scale = value
		pickup_collector.scale = Vector2(1, 1) * pickup_scale

var current_weapon : Weapon
var passives : Array[Node] = []

var speed_mult : float = 1.0
var exp_mult : float = 1.0
var defense : float = 1.0
var health_mult : float = 1.0:
	set(value):
		health = (health / health_mult) * value
		health_mult = value

var duration_mult : float = 1.0
var damage_mult : float = 1.0
var size_mult : float = 1.0
var num_attacks_mult : float = 1.0
var cooldown_mult : float = 1.0

signal died

func _ready() -> void:
	var spawner_node : Node2D = get_tree().get_first_node_in_group("Spawner")
	pickup_collector.scale = Vector2(1, 1) * pickup_scale
	if spawner_node:
		spawner_node.position = spawner_remote_transform.global_position
		spawner_remote_transform.remote_path = spawner_remote_transform.get_path_to(spawner_node)
	health *= health_mult
	health_man.set_max_health(health)
	PlayerManager.set_player(self)
	await HealthBarManager.ready_to_work
	HealthBarManager.update_health_bar_max(health)
	HealthBarManager.update_health_bar_value(health)

func _physics_process(_delta: float) -> void:
	var dir_x : int = int(Input.get_axis("ui_left", "ui_right"))
	var dir_y : int = int(Input.get_axis("ui_up", "ui_down"))
	velocity = Vector2(dir_x, dir_y).normalized() * base_speed
	move_and_slide()

func _on_pick_up_collector_area_entered(area: Area2D) -> void:
	var pick_up : PickUp = area.get_parent()
	pick_up.start_moving(self)

func get_exp(value : float) -> void:
	LevelUpManager.add_exp(value * exp_mult)
	AudioManager.play_song("ExpGet")

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		health_man.take_damage(body.contact_damage / defense)
		hurtbox.set_deferred("monitoring", false)
		modulate.a = 127
		get_tree().create_timer(invincibility_time).timeout.connect(func() -> void:
			hurtbox.set_deferred("monitoring", true)
			modulate.a = 255)

func equip_weapon(weapon : Weapon) -> void:
	weapon.parent = self
	add_child(weapon)
	current_weapon = weapon

func equip_passive(passive : Node) -> void:
	add_child(passive)
	passives.append(passive)

func equip_weapon_effect(effect : Effect) -> void:
	if current_weapon:
		current_weapon.add_new_effect(effect)

func _on_health_manager_died() -> void:
	AudioManager.play_song("PlayerDeath")
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
	died.emit()

func _on_health_manager_took_damage(_amount : float) -> void:
	on_health_changed()
	AudioManager.play_song("PlayerHit")

func _on_health_manager_healed() -> void:
	on_health_changed()
	AudioManager.play_song("PlayerHeal")

func on_health_changed() -> void:
	HealthBarManager.update_health_bar_value(health_man.health)
