class_name BulletDual
extends Bullet

@onready var bullet_spinners: Node3D = %BulletSpinners
@onready var bullet_a: Node3D = %A
@onready var bullet_b: Node3D = %B

var isDualBullet: bool = true

func _physics_process(delta: float) -> void:
	velocity = definedSpeed * delta
	move_and_slide()
	
	if isDualBullet:
		bullet_spinners.rotation.y += 5 * delta

func _bulletA_hit(body: Node3D) -> void:
	if "healthComponent" in body:
		print("damage!")
	if bullet_spinners.get_children().size() == 1:
		bullet_kill()
	else:
		bullet_a.queue_free()
		isDualBullet = false

func _bulletB_hit(body: Node3D) -> void:
	if "healthComponent" in body:
		print("damage!")
	if bullet_spinners.get_children().size() == 1:
		bullet_kill()
	else:
		bullet_b.queue_free()
		isDualBullet = false

func bullet_kill() -> void:
	queue_free()
