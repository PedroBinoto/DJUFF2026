extends Node3D

@export var angular_velocity: Vector3 = Vector3.UP * PI
var player: Node3D

func _ready() -> void:
	$AnimationPlayer.play("rotate", -1, angular_velocity.y)

func _on_body_entered(body: Node3D) -> void:
	player = body
	player.create_force(self, Vector3.ZERO)

func _process(_delta: float) -> void:
	if (player):
		var offset = Vector3((player.global_position.x - global_position.x), 0, (player.global_position.z - global_position.z))
		var force = angular_velocity.cross(offset)
		player.update_force(self, force * 0.6333)

func _on_body_exited(_body: Node3D) -> void:
	player.delete_force(self)
	player = null
