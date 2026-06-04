class_name Player
extends CharacterBody3D

@export var playerSpeed: float = 300

func _physics_process(delta: float) -> void:
	_handle_movement(delta)
	pass

func _handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_down", "move_up", "move_left", "move_right")
	# direction = direction.rotated(-PI / 4)
	
	var movement = direction * playerSpeed * delta
	velocity = Vector3(movement.x, 0, movement.y)
	
	move_and_slide()
