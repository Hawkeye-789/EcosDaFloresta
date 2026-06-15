extends CharacterBody2D
class_name Enemy

@export var move_speed : float = 30.0
@export var close_distance: float = 0.0
@export var far_distance : float = 0.0
@export var exp_drop : int = 1
@export var coins_drop : int = 1
@export var health: float = 1
@export var contact_damage : float = 1
@export var speed_increase : float = 0.1
@export var dmg_increase : float = 0.3
@export var hp_increase : float = 0.4
@export var exp_increase : float = 0.06
@export_group("Nodes")
@export var health_man : HealthManager
@export var anim : AnimationPlayer

@onready var noise : FastNoiseLite = FastNoiseLite.new()
@onready var exp_scene : PackedScene = preload("res://Utilities/PickUps/exp.tscn")
var player : CharacterBody2D

const PICKUP_SPAWN_AREA_WIDTH : float = 20
const BASE_NOISE_VELOCITY_MULTIPLIER : float = 0.3

signal died

var sleeping : bool = false
var on_fire : bool = false
var poisoned : bool = false
var being_knocked : bool = false

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	health_man.set_max_health(health)
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5

func upgrade(times : int) -> void:
	move_speed *= 1.0 + (speed_increase * times)
	contact_damage *= 1.0 + (dmg_increase * times)
	health *= 1.0 + (hp_increase * times)
	exp_drop = floor(exp_drop * 1.0 + (exp_increase * times))

func _physics_process(_delta: float) -> void:
	var direction : Vector2 = global_position.direction_to(player.global_position)
	if !being_knocked:
		velocity = direction * move_speed
		velocity += get_noise_velocity(Time.get_ticks_msec() / 1000.0)
	if !sleeping:
		move_and_slide()

func get_noise_velocity(time: float, velocity_multiplier : float = BASE_NOISE_VELOCITY_MULTIPLIER) -> Vector2:
	var nx : float = noise.get_noise_1d(time)     
	var ny : float = noise.get_noise_1d(time + 100)
	var dir : Vector2 = Vector2(nx, ny).normalized()
	return dir * move_speed * velocity_multiplier

func die() -> void:
	anim.play("dissolve")
	AudioManager.play_song("EnemyDeath")
	process_mode = Node.PROCESS_MODE_DISABLED
	await anim.animation_finished
	give_spoils()
	emit_sfx()
	died.emit()
	queue_free()

func emit_sfx() -> void:
	AudioManager.play_song("EnemyDeath")

func give_spoils() -> void:
	CoinManager.add_coins(coins_drop)
	spawn_pick_ups()

func get_random_position_for_spawn() -> Vector2:
	var min_x : float = global_position.x - (PICKUP_SPAWN_AREA_WIDTH/2)
	var max_x : float = global_position.x + (PICKUP_SPAWN_AREA_WIDTH/2)
	var min_y : float = global_position.y - (PICKUP_SPAWN_AREA_WIDTH/2)
	var max_y : float = global_position.y + (PICKUP_SPAWN_AREA_WIDTH/2)
	
	return Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)

func spawn_pick_ups() -> void:
	var exp_pickup : Exp = exp_scene.instantiate()
	exp_pickup.set_value(exp_drop)
	exp_pickup.global_position = get_random_position_for_spawn()
	get_tree().get_first_node_in_group("Game").call_deferred("add_child", exp_pickup)

func _on_health_manager_took_damage(_amount : float) -> void:
	anim.play("hitflash")
	AudioManager.play_song("EnemyHit")

func sleep_effect(duration : float) -> void:
	sleeping = true
	await get_tree().create_timer(duration).timeout
	sleeping = false

func burn_effect(duration : float, fire_damage : float) -> void:
	if on_fire:
		return
	on_fire = true
	var fire_timer : Timer = Timer.new()
	fire_timer.autostart = true
	fire_timer.one_shot = false
	fire_timer.wait_time = 1.0
	fire_timer.timeout.connect(func() -> void:
		health_man.take_damage(fire_damage)
		AudioManager.play_song("BurnHit")
		)
	call_deferred("add_child", fire_timer)
	get_tree().create_timer(duration).timeout.connect(func() -> void:
		fire_timer.queue_free()
		on_fire = false)

func poison_effect(duration : float, poison_damage : float, poison_slow : float) -> void:
	if poisoned:
		return
	poisoned = true
	var poison_timer : Timer = Timer.new()
	poison_timer.autostart = true
	poison_timer.one_shot = false
	poison_timer.wait_time = 1.0
	poison_timer.timeout.connect(func() -> void:
		health_man.take_damage(poison_damage)
		AudioManager.play_song("PoisonHit")
		)
	move_speed *= poison_slow
	call_deferred("add_child", poison_timer)
	get_tree().create_timer(duration).timeout.connect(func() -> void: 
		poison_timer.queue_free()
		poisoned = false
		move_speed /= poison_slow)

func knockback(knock_velocity : Vector2, duration : float) -> void:
	velocity = knock_velocity
	being_knocked = true
	await get_tree().create_timer(duration).timeout
	being_knocked = false

func _on_on_screen_notifier_screen_entered() -> void:
	add_to_group("Enemies")
