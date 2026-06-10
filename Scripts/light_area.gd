class_name LightArea
extends Area3D


@onready var ghost: GhostBoss = $"../../GhostBoss"
@onready var player: Player = $"../../Player"


func _on_body_entered(body: Node3D):
	var parent = body.get_parent() 
	if parent is BulletGhost:
		parent.setActive(false)
	if body is Player:
		ghost.seePlayer(true)
	if body is GhostBoss:
		ghost.isUnderLight = true

func _on_body_exited(body: Node3D):
	var parent = body.get_parent() 
	if parent is BulletGhost:
		parent.setActive(true)
	if body is Player:
		ghost.seePlayer(false)
	if body is GhostBoss:
		ghost.isUnderLight = false


func _on_area_entered(area: Area3D) -> void:
	_on_body_entered(area)

func _on_area_exited(area: Area3D) -> void:
	_on_body_exited(area)
