extends CanvasLayer
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass



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
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")
