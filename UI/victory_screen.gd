extends Control

@export_range(0.0, 5.0, 0.05) var final_blur_value : float = 4.0
@export_range(0.0, 1.0, 0.01) var final_darkness_value : float = 0.6
@export var blur_duration : float = 2.0
@export var generic_text_label : Label
@export var legend_text_label : Label
@export var color_rect : ColorRect
@export var legend_image : TextureRect
@export var show_image_duration : float = 1.6
@export var victory_screen_container : VBoxContainer
@export var play_again_container : VBoxContainer
@export var ok_button : Button

signal play_again
signal quit_to_menu

func _ready() -> void:
	generic_text_label.visible_ratio = 0.0
	legend_text_label.visible_ratio = 0.0
	legend_image.modulate = Color.TRANSPARENT
	play_again_container.visible = false
	ok_button.disabled = true
	ok_button.modulate = Color.TRANSPARENT
	#show_up()

func show_up() -> void:
	visible = true
	await blur_out()
	await show_text(generic_text_label)
	await show_legend()
	await show_ok_button()

func blur_out() -> void:
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property(color_rect.material, "shader_parameter/lod", final_blur_value, blur_duration).set_trans(Tween.TRANS_QUAD).set_delay(0.3)
	tween.tween_property(color_rect.material, "shader_parameter/darkness", final_darkness_value, blur_duration).set_trans(Tween.TRANS_CIRC)
	await tween.finished

func show_text(label : Label) -> void:
	var duration : float = label.get_total_character_count() * 0.03
	var tween := create_tween()
	await tween.tween_property(label, "visible_ratio", 1.0, duration).finished

func show_legend() -> void:
	await show_image()
	await show_text(legend_text_label)

func show_image() -> void:
	var tween := create_tween()
	await tween.tween_property(legend_image, "modulate", Color.WHITE, show_image_duration).finished

func show_question() -> void:
	victory_screen_container.visible = false
	play_again_container.visible = true

func show_ok_button() -> void:
	var tween := create_tween()
	await tween.tween_property(ok_button, "modulate", Color.WHITE, 1.6).finished
	ok_button.disabled = false

func _on_no_button_pressed() -> void:
	quit_to_menu.emit()

func _on_yes_button_pressed() -> void:
	play_again.emit()

func set_chosen_weapon(legend_info : LegendInfo) -> void:
	legend_image.texture = legend_info.image
	legend_text_label.text = legend_info.win_quote
