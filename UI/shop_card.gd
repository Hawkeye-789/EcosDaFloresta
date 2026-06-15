extends Button
class_name ShopCard

@export var soldout_texture : TextureRect
@export var icon_texture : TextureRect
@export var cost_label : CoinLabel
@export var name_label : Label

func fill_in(new_icon : Texture2D, new_name : String) -> void:
	icon_texture.texture = new_icon
	name_label.text = new_name

func change_soldout(soldout : bool) -> void:
	soldout_texture.visible = soldout

func set_cost(cost: int) -> void:
	cost_label.set_label_text(cost, true)
