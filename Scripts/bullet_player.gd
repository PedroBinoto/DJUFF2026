class_name BulletPlayer
extends Bullet

func _ready() -> void:
	definedSpeed = bulletSpeed * Vector3(moveDirection.x, 0, moveDirection.y)

func _physics_process(delta: float) -> void:
	velocity = definedSpeed * delta
	move_and_slide()

func _on_bullet_collide(body: Node3D) -> void:
	if "healthComponent" in body:
		print("damage!")
		queue_free()
	super._on_bullet_collide(body)
