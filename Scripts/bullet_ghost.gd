class_name BulletGhost
extends Bullet


var active = true
@onready var mesh: MeshInstance3D = $MeshInstance3D

var material:StandardMaterial3D = null


func _ready() -> void:
	material = mesh.get_active_material(0).duplicate() as StandardMaterial3D
	mesh.set_surface_override_material(0, material)
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color.a = 1
	
	super._ready()


func setActive(state:bool):
	if state == true:
		material.albedo_color.a = 1
	else:
		material.albedo_color.a = 0.1
	active = state


func _on_bullet_collide(body: Node3D) -> void:
	if not active:
		return
	if body is GhostBoss:
		return
	super._on_bullet_collide(body)
	pass
