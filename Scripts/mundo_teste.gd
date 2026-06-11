extends Node3D

@export var bossName: String = ""
@export var bossNode: CharacterBody3D = null
@onready var pause: CanvasLayer = %Pause
@onready var camera_3d: Camera3D = %Camera3D

func _ready() -> void:
	get_tree().paused = true
	SignalBus.updateBossStats.emit(bossName, bossNode.healthComponent.maxHealth)
	SignalBus.pauseGame.connect(pause.pauseMenu)
	SignalBus.shakeCamera.connect(shake_camera)
	await get_tree().create_timer(3.5).timeout
	get_tree().paused = false

func _on_area_3d_area_entered(area: Area3D) -> void:
	pass # Replace with function body.

func shake_camera() -> void:
	print("shake!")
	camera_3d._camera_shake()
