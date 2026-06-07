extends MarginContainer
@onready var opções: HBoxContainer = $HBoxContainer

@onready var controles: Panel = $Controles


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	opções.visible = true
	controles.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mundo_teste.tscn")


func _on_controls_pressed() -> void:
	opções.visible = false
	controles.visible = true


func _on_credits_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/creditos.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_voltar_pressed() -> void:
	opções.visible = true
	controles.visible = false
