extends CanvasLayer
# false = esquerda / fantasma
# true = direita / magnetro
var choose_boss: bool

var isMagnetroAlive := true
var isGhoulstAlive := true
#func _input(event: InputEvent) -> void:
	#if event is InputEventKey:
		#if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			#choose_boss = false
		#elif event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			#choose_boss = true
		
func _process(delta: float) -> void:
	if not isMagnetroAlive and not isGhoulstAlive:
		get_tree().change_scene_to_file("res://Scenes/Victory.tscn")

func _on_passado_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ghostFight.tscn")


func _on_futuro_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/mundo_teste.tscn")


func _on_voltar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/MenuPrincipal.tscn")
