extends OptionButton
@onready var comandos_label = $"../ComandosLabel"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item("Configuração 1")
	add_item("Configuração 2")
	add_item("Configuração 3")
	var index = 0
	match index:
		0:
			comandos_label.text = """Mover: WASD
Ataque Espada: K
Ataque Arma: L
"""


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_item_selected(index: int) -> void:
	match index:
		0:
			comandos_label.text = """Mover: WASD
Ataque Espada: K
Ataque Arma: L
"""
		1:
			comandos_label.text = """Mover: Setas
Ataque Espada: Z
Ataque Arma: X
"""
		2:
			comandos_label.text = """Mover: WASD
Ataque Espada: Botão esquerdo do mouse
Ataque Arma: Botão direito do mouse
"""
	aplicar_configuracao(index)
	

func aplicar_configuracao(index):
	limpar_inputs()

	match index:
		0:
			adicionar_tecla("move_up", KEY_W)
			adicionar_tecla("move_down", KEY_S)
			adicionar_tecla("move_left", KEY_A)
			adicionar_tecla("move_right", KEY_D)

			adicionar_tecla("attack_a", KEY_K)
			adicionar_tecla("attack_b", KEY_L)

		1:
			adicionar_tecla("move_up", KEY_UP)
			adicionar_tecla("move_down", KEY_DOWN)
			adicionar_tecla("move_left", KEY_LEFT)
			adicionar_tecla("move_right", KEY_RIGHT)

			adicionar_tecla("attack_a", KEY_Z)
			adicionar_tecla("attack_b", KEY_X)

		2:
			adicionar_tecla("move_up", KEY_W)
			adicionar_tecla("move_down", KEY_S)
			adicionar_tecla("move_left", KEY_A)
			adicionar_tecla("move_right", KEY_D)

			adicionar_mouse("attack_a", MOUSE_BUTTON_LEFT)
			adicionar_mouse("attack_b", MOUSE_BUTTON_RIGHT)
			
			
			
func adicionar_tecla(action, keycode):
	var event = InputEventKey.new()
	event.keycode = keycode
	InputMap.action_add_event(action, event)
	
func limpar_inputs():
	var actions = [
		"move_up",
		"move_down",
		"move_left",
		"move_right",
		"attack_a",
		"attack_b"
	]

	for action in actions:
		InputMap.action_erase_events(action)
		
func adicionar_mouse(action, button):
	var event = InputEventMouseButton.new()
	event.button_index = button
	InputMap.action_add_event(action, event)
	
