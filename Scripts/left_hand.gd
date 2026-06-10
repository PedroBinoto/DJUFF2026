extends Node3D

@export var min_speed := 5.0
@export var max_speed := 50.0
@export var max_distance := 20.0

var target_position: Vector3
var attacking := false

func _physics_process(delta):
	if attacking:
		var distance = global_position.distance_to(target_position)
		var t = 1.0 - clamp(distance / max_distance, 0.0, 1.0)
		var speed = lerp(min_speed, max_speed, t)
		global_position = global_position.move_toward(target_position, speed * delta)
		
func _on_left_hand_entered(body: Node3D) -> void:
	if "healthComponent" in body:
		print("damage!")
