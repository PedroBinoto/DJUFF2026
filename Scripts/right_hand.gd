extends Node3D

@export var speed := 20.0

var target_position: Vector3
var attacking := false

func _physics_process(delta):
	if attacking:
		global_position = global_position.move_toward(target_position,speed * delta)
		
func _on_right_hand_entered(body: Node3D) -> void:
	if "healthComponent" in body:
		print("damage!")
