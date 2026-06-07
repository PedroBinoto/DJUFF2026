class_name MagnetBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 50 * delta
	move_and_slide()

func _process(delta: float) -> void:
	pass
