class_name Bullet
extends CharacterBody3D

var moveDirection: Vector2i = Vector2i.ZERO
@export var bulletSpeed: float = 500

var definedSpeed: Vector3 = Vector3.ZERO

func _ready() -> void:
	definedSpeed = bulletSpeed * Vector3(moveDirection.x, 0, moveDirection.y)

func _physics_process(delta: float) -> void:
	velocity = definedSpeed * delta
	move_and_slide()

func _on_bullet_collide(body: Node3D) -> void:
	if "healthComponent" in body:
		print("damage!")
		queue_free()
	elif body is StaticBody3D:
		queue_free()
