extends MarginContainer
@onready var opções: HBoxContainer = $HBoxContainer
@onready var creditos: ScrollContainer = $"../Creditos"

@onready var controles: Panel = $Controles
@onready var polar: AudioStreamPlayer = $Polar

var veio_do_pause = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opções.visible = true
	controles.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	hide()
	polar.stream_paused = true


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
