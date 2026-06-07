extends ScrollContainer
@onready var menu_principal: MarginContainer = $"../MenuPrincipal"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_button_pressed() -> void:
	hide()
	menu_principal.show()
