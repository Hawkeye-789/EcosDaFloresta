extends CharacterBody2D
class_name Player

@export var base_speed : float
@export var spawner_remote_transform : RemoteTransform2D
@export var pickup_collector : Area2D
@export var health : float
@export var health_man : HealthManager
@export var pickup_scale : float = 100.0:
	set(value):
		pickup_scale = value
		pickup_collector.scale = Vector2(1, 1) * pickup_scale

var current_weapon : Weapon
var passives : Array[Node] = []

var speed_mult : float = 1
var exp_mult : float = 1
var defense : float = 1

var duration_mult : float = 1:
	set(value):
		if current_weapon:
			current_weapon.duration = (current_weapon.duration / duration_mult) * value
		duration_mult = value
var damage_mult : float = 1:
	set(value):
		if current_weapon:
			current_weapon.damage = (current_weapon.damage / damage_mult) * value
		damage_mult = value
var size_mult : float = 1:
	set(value):
		if current_weapon:
			current_weapon.size = (current_weapon.size / size_mult) * value
		size_mult = value
var num_attacks_mult : float = 1:
	set(value):
		if current_weapon:
			current_weapon.num_attacks = floor((current_weapon.num_attacks / num_attacks_mult) * value)
		num_attacks_mult = value
var cooldown_mult : float = 1:
	set(value):
		if current_weapon:
			current_weapon.cooldown = (current_weapon.cooldown / cooldown_mult) * value
		cooldown_mult = value

func _ready() -> void:
	var spawner_node : Node2D = get_tree().get_first_node_in_group("Spawner")
	pickup_collector.scale = Vector2(1, 1) * pickup_scale
	if spawner_node:
		spawner_node.position = spawner_remote_transform.global_position
		spawner_remote_transform.remote_path = spawner_remote_transform.get_path_to(spawner_node)
	
	health_man.set_max_health(health)
	PlayerManager.set_player(self)

func _physics_process(_delta: float) -> void:
	var dir_x : int = int(Input.get_axis("left", "right"))
	var dir_y : int = int(Input.get_axis("up", "down"))
	velocity = Vector2(dir_x, dir_y).normalized() * base_speed
	move_and_slide()

func _on_pick_up_collector_area_entered(area: Area2D) -> void:
	var pick_up : PickUp = area.get_parent()
	pick_up.start_moving(self)

func get_exp(value : int) -> void:
	LevelUpManager.add_exp(value * exp_mult)

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body is Enemy:
		health_man.take_damage(body.contact_damage)

func equip_weapon(weapon : Weapon) -> void:
	add_child(weapon)
	current_weapon = weapon

func equip_passive(passive : Node) -> void:
	add_child(passive)
	passives.append(passive)

func equip_weapon_effect(effect : Effect) -> void:
	if current_weapon:
		current_weapon.add_new_effect(effect)
