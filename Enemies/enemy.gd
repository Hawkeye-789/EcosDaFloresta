extends CharacterBody2D
class_name Enemy

@export var move_speed : float = 30.0
@export var close_distance: float = 0.0
@export var far_distance : float = 0.0
@export var exp_drop : float = 1.0
@export var health: float = 1
@export var contact_damage : float = 1
@export_group("Nodes")
@export var health_man : HealthManager
@export var anim : AnimationPlayer

@onready var noise : FastNoiseLite = FastNoiseLite.new()
@onready var exp_scene : PackedScene = preload("res://Utilities/PickUps/exp.tscn")
var player : CharacterBody2D

var repelling : bool = false

const PICKUP_SPAWN_AREA_WIDTH : float = 20
const BASE_NOISE_VELOCITY_MULTIPLIER : float = 0.3

signal died

var sleeping : bool = false
var on_fire : bool = false
var poisoned : bool = false
var being_knocked : bool = false

func _ready() -> void:
	add_to_group("Enemies")
	player = get_tree().get_first_node_in_group("Player")
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.5
	
	health_man.set_max_health(health)

func _physics_process(_delta: float) -> void:
	update_state()
	
	var direction = global_position.direction_to(player.global_position)
	if repelling:
		direction *= -1
	if !being_knocked:
		velocity = direction * move_speed
		velocity += get_noise_velocity(Time.get_ticks_msec() / 900.0)
	if !sleeping:
		move_and_slide()

func update_state() -> void:
	var distance: float = global_position.distance_to(player.global_position)

	if not repelling and distance < close_distance:
		repelling = true
	elif repelling and distance > far_distance and !is_zero_approx(close_distance):
		repelling = false

func get_noise_velocity(time: float, velocity_multiplier : float = BASE_NOISE_VELOCITY_MULTIPLIER) -> Vector2:
	var nx = noise.get_noise_1d(time)     
	var ny = noise.get_noise_1d(time + 100)
	var dir = Vector2(nx, ny).normalized()
	return dir * move_speed * velocity_multiplier

func get_noised_velocity(current_velocity : Vector2) -> Vector2:
	return current_velocity.normalized() * move_speed

func die() -> void:
	spawn_pick_ups()
	died.emit()
	queue_free()

func calculate_pickups(total_xp: int) -> Dictionary:
	var result := {
		"Big": 0,
		"Medium": 0,
		"Small": 0,
	}

	var remaining = total_xp
	var values = [
		{"name": "Big", "value": Exp.ExpValues.Big},
		{"name": "Medium", "value": Exp.ExpValues.Medium},
		{"name": "Small", "value": Exp.ExpValues.Small},
	]

	for v in values:
		var count = remaining / v.value
		result[v.name] = count
		remaining -= count * v.value

	return result

func get_random_position_for_spawn() -> Vector2:
	var min_x = global_position.x - (PICKUP_SPAWN_AREA_WIDTH/2)
	var max_x = global_position.x + (PICKUP_SPAWN_AREA_WIDTH/2)
	var min_y = global_position.y - (PICKUP_SPAWN_AREA_WIDTH/2)
	var max_y = global_position.y + (PICKUP_SPAWN_AREA_WIDTH/2)
	
	return Vector2(
		randf_range(min_x, max_x),
		randf_range(min_y, max_y)
	)

func spawn_pick_ups() -> void:
	var drops = calculate_pickups(floor(exp_drop))

	for type in drops.keys():
		for i in range(drops[type]):
			var exp_pickup : Exp = exp_scene.instantiate()
			
			match type:
				"Small": exp_pickup.set_value(Exp.ExpValues.Small)
				"Medium": exp_pickup.set_value(Exp.ExpValues.Medium)
				"Big": exp_pickup.set_value(Exp.ExpValues.Big)
			
			exp_pickup.global_position = get_random_position_for_spawn()
			get_tree().current_scene.call_deferred("add_child", exp_pickup)

func _on_health_manager_took_damage() -> void:
	anim.play("hitflash")

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
	fire_timer.timeout.connect(func(): health_man.take_damage(fire_damage))
	call_deferred("add_child", fire_timer)
	get_tree().create_timer(duration).timeout.connect(func():
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
	poison_timer.timeout.connect(func(): health_man.take_damage(poison_damage))
	move_speed *= poison_slow
	call_deferred("add_child", poison_timer)
	get_tree().create_timer(duration).timeout.connect(func(): 
		poison_timer.queue_free()
		poisoned = false
		move_speed /= poison_slow)

func knockback(knock_velocity : Vector2, duration : float) -> void:
	velocity = knock_velocity
	being_knocked = true
	await get_tree().create_timer(duration).timeout
	being_knocked = false
