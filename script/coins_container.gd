extends Control
class_name HUD

@export var coin_label: Label

func update_coin(amount: int):
	coin_label.text = "%d" % amount
