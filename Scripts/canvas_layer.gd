extends CanvasLayer
# false = esquerda / fantasma
# true = direita / magnetro
var choose_boss: bool


func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_A or event.keycode == KEY_LEFT:
			choose_boss = false
		elif event.keycode == KEY_D or event.keycode == KEY_RIGHT:
			choose_boss = true
		
