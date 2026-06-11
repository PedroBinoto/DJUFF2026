class_name MagBox
extends RigidBody3D

var target_position: Vector3
var moving := false

@export var healthComponent: HealthComponent = null
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _physics_process(delta):
	if moving and global_position.distance_to(target_position) < 1.0:
		linear_velocity = Vector3.ZERO
		moving = false


func _on_area_3d_body_entered(body: Node3D) -> void:
	if moving and "healthComponent" in body:
		body.healthComponent.damage(10)
	#audio_stream_player.play()
	

func die():
	pass
