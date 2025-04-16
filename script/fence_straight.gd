extends Node3D

func _on_area_3d_body_entered(body: Node3D) -> void:
	print("Colidiu saporra")
	if body.name == "Player":
		body.is_dead = true
