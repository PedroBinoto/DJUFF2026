extends OptionButton
@onready var comandos_label = $"../ComandosLabel"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_item("Configuração 1")
	add_item("Configuração 2")
	add_item("Configuração 3")


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
