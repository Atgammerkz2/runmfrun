extends CanvasLayer

var nod_threshold_up = 1.5 # Radianos/segundo, ajuste conforme necessário
var nod_threshold_down = -1.5 # Radianos/segundo, ajuste
var nod_time_window = 0.5 # Segundos para completar o aceno
var time_since_nod_up = 0.0
var nod_up_detected = false

func _process(delta):
	var gyro_pitch_velocity = Input.get_gyroscope().x

	if nod_up_detected:
			time_since_nod_up += delta
			if time_since_nod_up > nod_time_window:
				nod_up_detected = false # Resetar se demorar demais
			elif gyro_pitch_velocity < nod_threshold_down:
				print("Jogo iniciado pelo aceno!")
				_on_iniciar_btn_pressed()
				nod_up_detected = false
				# Desabilitar processamento de gesto do menu aqui
	elif gyro_pitch_velocity > nod_threshold_up:
			nod_up_detected = true
			time_since_nod_up = 0.0

func _on_iniciar_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://world.tscn")


func _on_sair_btn_pressed() -> void:
	get_tree().quit()
