extends CanvasLayer
@onready var menu_principal: MarginContainer = $"../MenuPrincipal"
@onready var polar: AudioStreamPlayer = $"../MenuPrincipal/Polar"

var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pauseMenu():

	if paused:
		hide()
		Engine.time_scale = 1
	else:
		show()
		Engine.time_scale = 0

	paused = !paused


func _on_resume_pressed() -> void:
	pauseMenu()


func _on_quit_pressed() -> void:
	pauseMenu()
	menu_principal.voltar_para_menu_principal()
	polar.stream_paused = false


func _on_button_2_pressed() -> void:
	hide()

	menu_principal.show()
	menu_principal.opções.visible = false
	menu_principal.controles.visible = true

	menu_principal.veio_do_pause = true
