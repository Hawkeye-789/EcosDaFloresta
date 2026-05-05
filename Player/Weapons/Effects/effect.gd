extends Node
class_name Effect

var parent : Attack

func _ready() -> void:
	if !parent:
		assert(get_parent() is Attack, "Efeito com pai que não é da classe Ataque!! Em " + name + " que tem pai " + get_parent().name)
		parent = get_parent() as Attack
	connect_parent()

func connect_parent() -> void:
	parent.hit.connect(apply_effect)

func apply_effect(target : CharacterBody2D) -> void:
	if target is Enemy:
		print("Sex")
