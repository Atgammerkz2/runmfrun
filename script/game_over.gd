extends CanvasLayer


func _on_retry_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()
