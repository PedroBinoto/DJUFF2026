extends Node3D

		
func _on_left_hand_entered(body: Node3D) -> void:
	body.healthComponent.damage(10)
