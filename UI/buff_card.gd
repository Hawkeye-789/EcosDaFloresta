extends Control
class_name BuffCard

@export var mouse_scale_multiplier : float = 1.05
@export var v_container : VBoxContainer
@export var name_label : Label
@export var image : TextureRect
@export var description_label : Label

var current_buff : CardInfo
signal chosen(card : BuffCard, info : CardInfo)

func _ready() -> void:
	change_contents_visibility(false)
	custom_minimum_size = Vector2.ZERO
	var tween = create_tween()
	tween.finished.connect(change_contents_visibility.bind(true))
	tween.tween_property(self, "custom_minimum_size", size, 0.6).set_ease(Tween.EASE_OUT)

func change_contents_visibility(visibility : bool) -> void:
	for container in v_container.get_children():
		container.visible = visibility

func _on_mouse_entered() -> void:
	custom_minimum_size *= mouse_scale_multiplier

func _on_mouse_exited() -> void:
	custom_minimum_size /= mouse_scale_multiplier

func fill_in(new_buff : CardInfo) -> void:
	current_buff = new_buff
	name_label.text = new_buff.name
	image.texture = new_buff.image
	description_label.text = new_buff.description

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			chosen.emit(self, current_buff)
