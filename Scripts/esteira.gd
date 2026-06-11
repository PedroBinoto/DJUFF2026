extends Node3D

@export var linear_velocity: Vector3 = Vector3.LEFT * PI
var player: Node3D
@onready var mesh: MeshInstance3D = %Mesh


func _ready() -> void:
	mesh.get_active_material(0).set_shader_parameter("Speed", sign(linear_velocity.x) * .4)

func _on_body_entered(body: Node3D) -> void:
	player = body
	player.create_force(self, Vector3.ZERO)

func _process(_delta: float) -> void:
	if (player):
		var force = linear_velocity.rotated(Vector3.UP, rotation.y)
		player.update_force(self, force * 0.68)

func _on_body_exited(_body: Node3D) -> void:
	player.delete_force(self)
	player = null
