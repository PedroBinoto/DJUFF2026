class_name HealthComponent
extends Node

@export var component_owner: Node = null

@export var maxHealth: float = 0.0
@onready var health: float = maxHealth

func heal(val: float) -> void:
	health = clamp(health + val, 0.0, maxHealth)

func damage(val: float) -> void:
	health = clamp(health - val, 0.0, maxHealth)
	if health <= 0:
		die()

func die() -> void:
	component_owner.die()
