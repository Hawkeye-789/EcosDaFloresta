extends Control

@export var color_rect : ColorRect
@export var game_over_label : Label
@export var try_again_container : HBoxContainer
@export var left_button : Button
@export var right_button : Button
@export var legend_text : Label
@export var legend_portrait : TextureRect

const TWEEN_DURATION : float = 0.5
const CONTAINER_OFFSET_Y : float = 40

signal retry
signal end(go_title : bool)

func _ready() -> void:
	visible = false
	color_rect.modulate = Color.TRANSPARENT
	game_over_label.modulate = Color.TRANSPARENT
	try_again_container.modulate = Color.TRANSPARENT
	legend_portrait.modulate = Color.TRANSPARENT
	legend_text.visible_ratio = 0.0
	#show_up()

func show_up() -> void:
	visible = true
	AudioManager.stop("LevelMusic")
	AudioManager.play_song("GameOverMusic")
	await fade_out()
	await show_label()
	await show_legend()
	show_buttons()

func fade_out() -> void:
	var tween := create_tween()
	await tween.tween_property(color_rect,"modulate", Color.WHITE, TWEEN_DURATION * 3).finished

func show_label() -> void:
	var tween := create_tween()
	await tween.tween_property(game_over_label,"modulate", Color.WHITE, TWEEN_DURATION * 2).finished

func set_legend(info : LegendInfo) -> void:
	legend_portrait.texture = info.image
	legend_text.text = info.death_quote

func show_legend() -> void:
	var tween := create_tween()
	tween.tween_property(legend_portrait, "modulate", Color.WHITE, TWEEN_DURATION * 2)
	tween.tween_property(legend_text, "visible_ratio", 1.0, TWEEN_DURATION * 4)
	await tween.finished

func show_buttons() -> void:
	var initial_pos : Vector2 = try_again_container.position
	try_again_container.position += Vector2(0, CONTAINER_OFFSET_Y)
	left_button.disabled = true
	right_button.disabled = true
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(try_again_container,"modulate", Color.WHITE, TWEEN_DURATION * 2).set_trans(Tween.TRANS_LINEAR).set_delay(0.3)
	tween.tween_property(try_again_container, "position", initial_pos, TWEEN_DURATION * 2)
	await tween.finished
	
	left_button.disabled = false
	right_button.disabled = false
	left_button.pressed.connect(restart)
	right_button.pressed.connect(give_up)

func restart() -> void:
	retry.emit()

func give_up() -> void:
	left_button.disabled = true
	right_button.disabled = true

	var tween := create_tween()
	tween.tween_property(
		try_again_container,
		"modulate",
		Color.TRANSPARENT,
		TWEEN_DURATION
	)
	tween.tween_callback(func() -> void:
		left_button.text = "Voltar a tela inicial"
		left_button.pressed.disconnect(restart)
		left_button.pressed.connect(back_to_title)
		right_button.text = "Sair do jogo"
		right_button.pressed.disconnect(give_up)
		right_button.pressed.connect(quit)
	)
	tween.tween_property(
		try_again_container,
		"modulate",
		Color.WHITE,
		TWEEN_DURATION
	).set_delay(0.3)
	await tween.finished

	left_button.disabled = false
	right_button.disabled = false

func back_to_title() -> void:
	end.emit(true)

func quit() -> void:
	end.emit(false)
