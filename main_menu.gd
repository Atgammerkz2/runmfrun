extends CanvasLayer

func _on_iniciar_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://world.tscn")


func _on_sair_btn_pressed() -> void:
	get_tree().quit()
