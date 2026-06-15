extends Enemy
class_name Boss

@export var boss_name : String = ""

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	health_man.set_max_health(health)
	BossBarManager.set_boss_bar_max(health)
	BossBarManager.set_boss_name(boss_name)
	BossBarManager.show_boss_bar()
	health_man.took_damage.connect(BossBarManager.decrease_boss_bar_value)
	died.connect(BossBarManager.clear_boss_bar)

func get_noise_velocity(_time: float, _velocity_multiplier : float = BASE_NOISE_VELOCITY_MULTIPLIER) -> Vector2:
	return Vector2.ZERO

func emit_sfx() -> void:
	AudioManager.play_song("BossDeath")
 
func _on_died() -> void:
	BossBarManager.hide_boss_bar()
