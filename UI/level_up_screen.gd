extends Control

@export var buffs : Array[BuffInfo]

func _ready() -> void:
	exhibit()

func choose_three_randoms() -> Vector3i:
	var indices := range(buffs.size())
	indices.shuffle()
	
	return Vector3i(indices[0], indices[1], indices[2])

func fill_in_card(card : BuffCard, index : int) -> void:
	card.fill_in(buffs[index])
	card.chosen.connect(buff_chosen.bind(index))

func buff_chosen(index : int) -> void:
	print("Buff no° ", index, " foi escolhido!!!")

func exhibit() -> void:
	var indexes : Vector3i = choose_three_randoms()
	var containers := $HBoxContainer.get_children()
	var buff_cards : Array[BuffCard]
	for container in containers:
		buff_cards.push_back(container.get_child(0))
	for i in range(buff_cards.size()):
		fill_in_card(buff_cards[i], indexes[i])
	visible = true
