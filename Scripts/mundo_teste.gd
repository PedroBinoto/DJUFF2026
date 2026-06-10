extends Node3D

@export var bossName: String = ""
@export var bossNode: CharacterBody3D = null
@onready var pause: CanvasLayer = %Pause

func _ready() -> void:
	SignalBus.updateBossStats.emit(bossName, bossNode.healthComponent.maxHealth)
	SignalBus.pauseGame.connect(pause.pauseMenu)

func _on_area_3d_area_entered(area: Area3D) -> void:
	pass # Replace with function body.
