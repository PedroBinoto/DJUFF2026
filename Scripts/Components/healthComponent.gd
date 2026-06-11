class_name HealthComponent
extends Node

@export var component_owner: Node = null

@export var maxHealth: float = 0.0
@onready var health: float = maxHealth

func heal(val: float) -> void:
	health = clamp(health + val, 0.0, maxHealth)

func damage(val: float) -> void:
	health = clamp(health - val, 0.0, maxHealth)
	if component_owner is GhostBoss or component_owner is MagnetBoss:
		SignalBus.updateBossbar.emit(health)
	if component_owner is Player:
		SignalBus.updatePlayerbar.emit(health)
	if !(component_owner is MagBox):
		SignalBus.shakeCamera.emit()
	if health <= 0:
		die()

func health_percent():
	return health/maxHealth

func die() -> void:
	component_owner.die()
