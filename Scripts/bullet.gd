class_name Bullet
extends CharacterBody3D

var moveDirection: Vector2 = Vector2.ZERO
@export var bulletSpeed: float = 500
@export var damage:float = 10

var definedSpeed: Vector3 = Vector3.ZERO

func _ready() -> void:
	definedSpeed = bulletSpeed * Vector3(moveDirection.x, 0, moveDirection.y)

func _physics_process(delta: float) -> void:
	velocity = definedSpeed * delta
	move_and_slide()

func _on_bullet_collide(body: Node3D) -> void:
	if body is StaticBody3D or body is RigidBody3D:
		queue_free()
	if "healthComponent" in body:
		body.healthComponent.damage(damage)
		print(body.healthComponent.health)
		queue_free()

func spawn(position:Vector3, spawner):
	scale = Vector3(0.001, 0.001, 0.001)
	var moveDir3D = spawner.global_position - position
	moveDirection = -Vector2(moveDir3D.x, moveDir3D.z).normalized()
	spawner.get_tree().root.add_child(self)
	global_position = position
	
	var growTween = get_tree().create_tween()
	growTween.tween_property(self, "scale", Vector3.ONE, 0.1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
