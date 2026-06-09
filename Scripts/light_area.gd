class_name LightArea
extends Area3D


func _on_body_entered(body: Node3D):
	var parent = body.get_parent() 
	if parent is BulletGhost:
		parent.setActive(false)

func _on_body_exited(body: Node3D):
	var parent = body.get_parent() 
	if parent is BulletGhost:
		parent.setActive(true)


func _on_area_entered(area: Area3D) -> void:
	_on_body_entered(area)

func _on_area_exited(area: Area3D) -> void:
	_on_body_exited(area)
