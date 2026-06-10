extends Node3D

@export var bossName: String = ""
@export var bossNode: CharacterBody3D = null

func _ready() -> void:
	SignalBus.updateBossStats.emit(bossName, bossNode.healthComponent.maxHealth)
