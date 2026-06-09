class_name Bullet
extends CharacterBody3D

var moveDirection: Vector2 = Vector2.ZERO
@export var bulletSpeed: float = 500

var definedSpeed: Vector3 = Vector3.ZERO

func _ready() -> void:
	definedSpeed = bulletSpeed * Vector3(moveDirection.x, 0, moveDirection.y)

func _physics_process(delta: float) -> void:
	velocity = definedSpeed * delta
	move_and_slide()

func _on_bullet_collide(body: Node3D) -> void:
	if body is StaticBody3D:
		queue_free()

func spawn(position:Vector3, spawner):
	var moveDir3D = spawner.global_position - position
	moveDirection = -Vector2(moveDir3D.x, moveDir3D.z).normalized()
	spawner.get_tree().root.add_child(self)
	global_position = position
