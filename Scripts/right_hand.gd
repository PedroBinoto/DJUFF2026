extends Node3D
		
func _on_right_hand_entered(body: Node3D) -> void:
	if "healthComponent" in body:
		body.healthComponent.damage(10)
