extends MarginContainer
@onready var opções: HBoxContainer = $HBoxContainer
@onready var creditos: ScrollContainer = $"../Creditos"

@onready var controles: Panel = $Controles
@onready var polar: AudioStreamPlayer = $Polar
@onready var audio_control_2: HSlider = %AudioControl2
@onready var audio_control: HSlider = %AudioControl
@onready var audio_control_3: HSlider = %AudioControl3

var veio_do_pause = false

func _ready() -> void:
	get_tree().paused = false
	opções.visible = true
	controles.visible = false
	audio_control.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Musica")))
	audio_control_2.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	audio_control_3.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	polar.play()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("uid://hcvcj2ye8egq")


func _on_controls_pressed() -> void:
	opções.visible = false
	controles.visible = true


func _on_credits_pressed() -> void:
	hide()
	creditos.show()


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_voltar_pressed() -> void:
	controles.visible = false
	opções.visible = true

	if veio_do_pause:
		hide()
		get_parent().get_node("Menu").show()
		veio_do_pause = false
		

func voltar_para_menu_principal():
	opções.visible = true
	controles.visible = false
	veio_do_pause = false
	show()
