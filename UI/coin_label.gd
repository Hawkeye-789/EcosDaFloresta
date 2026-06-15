extends HBoxContainer
class_name CoinLabel

@export var label : Label
@export var anim_duration_per_tick : float = 0.01
@export var shop_use : bool = false

func _ready() -> void:
	if !shop_use:
		connect_coin_manager()

func connect_coin_manager() -> void:
	CoinManager.coins_changed.connect(change_value_to)
	set_label_text(CoinManager.coins, true)

func change_value_to(target_value : int, instant : bool) -> void:
	if not is_visible_in_tree():
		set_label_text(target_value, true)
		return
	if instant:
		set_label_text(target_value, instant)
		return
	else:
		var initial_value : int = label.text.to_int()
		var difference : int = abs(target_value - initial_value)
		var tween := create_tween()
		tween.tween_method(set_label_text.bind(instant), initial_value, target_value, anim_duration_per_tick * difference).set_ease(Tween.EASE_OUT)

func set_label_text(value : int, instant : bool) -> void:
	label.text = str(value)
	if not (shop_use or instant):
		AudioManager.play_song("Money")
