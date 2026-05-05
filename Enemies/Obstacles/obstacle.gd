extends Enemy
class_name Obstacle

@export var pickup_scenes : Array[PackedScene]
@export var pickup_spawn_chances : Array[float]

func _ready() -> void:
	add_to_group("Enemies")
	health_man.set_max_health(health)

func _physics_process(_delta: float) -> void:
	pass

func die() -> void:
	spawn_pick_ups()

func chose_pickup() -> PickUp:
	var rand_n : float = randf()
	var cumulative : float = 0.0
	for i in pickup_scenes.size():
		cumulative += pickup_spawn_chances[i]
		if cumulative >= rand_n:
			return pickup_scenes[i].instantiate()
	return pickup_scenes[0].instantiate()

func spawn_pick_ups() -> void:
	assert(pickup_scenes.size() == pickup_spawn_chances.size(), "Pickup Scenes tem tamanho diferente de PickupSpawnChances in Obstacle! De "
									+ str(pickup_scenes.size()) + " e " + str(pickup_spawn_chances.size()) )
	var total_chance : float = 0.0
	for chance in pickup_spawn_chances:
		total_chance += chance
	assert(is_equal_approx(total_chance, 1.0), "Total das chances de Pickup Spawns em Obstacle não somam em 1!! Em vez disso em: " + str(total_chance))
	
	var pickup : PickUp = chose_pickup()
	pickup.position = get_random_position_for_spawn()
	get_tree().current_scene.call_deferred("add_child", pickup)
