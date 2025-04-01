extends HBoxContainer

@onready var coin_label: Label = $"../coin_label"


func update_coin(amount: int):
	coin_label.text = "%d" % amount
