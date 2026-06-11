class_name BulletGhost
extends Bullet


var active = true
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var projetil_2: Node3D = %Projetil
@onready var projetil: Node3D = %Projetil2


var material:StandardMaterial3D = null


func _ready() -> void:
	projetil.visible = true
	projetil_2.visible = false
	
	super._ready()


func setActive(state:bool):
	if state == true:
		projetil.visible = true
		projetil_2.visible = false
	else:
		projetil.visible = false
		projetil_2.visible = true
	active = state


func _on_bullet_collide(body: Node3D) -> void:
	if not active:
		return
	if body is GhostBoss:
		return
	super._on_bullet_collide(body)
	pass
