extends CanvasLayer
@onready var polar: AudioStreamPlayer = $"../MenuPrincipal/Polar"

@onready var controles: Panel = $Controles
@onready var pause_menu: Control = %PauseMenu

@onready var audio_control_3: HSlider = %AudioControl3 # Geral
@onready var audio_control: HSlider = %AudioControl # Musica
@onready var audio_control_2: HSlider = %AudioControl2 # Efeitos

var paused = false

func _ready() -> void:
	audio_control.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica")))
	audio_control_2.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	audio_control_3.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))

func pauseMenu():
	if paused:
		hide()
		get_tree().paused = false
	else:
		show()
	paused = !paused

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_action_pressed("pause"):
			pauseMenu()

func _on_resume_pressed() -> void:
	pauseMenu()

func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("uid://djbymk1ojtqrp")

func _on_button_2_pressed() -> void:
	pause_menu.visible = false
	controles.visible = true

func _on_voltar_pressed() -> void:
	pause_menu.visible = true
	controles.visible = false
