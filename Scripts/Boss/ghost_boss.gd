class_name GhostBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null
@export var bulletSpawnRingRadius: float = 1

@onready var bulletScene = preload("uid://b83onsyjngaor")
@onready var bullet_spawn_ring: Node3D = $BulletSpawnRing
@export var shootTimeLimit = 1

var shootTimer = 0


func _ready():
	setupBulletSpawnRing()


func setupBulletSpawnRing():
	var index = 0
	var numberOfSpawns = bullet_spawn_ring.get_child_count()
	for spawn in bullet_spawn_ring.get_children():
		var angle = 2*PI/numberOfSpawns * index
		spawn.set_position(Vector3(cos(angle), 0, sin(angle)) * bulletSpawnRingRadius)
		index+=1


func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 50 * delta
	move_and_slide()


func shoot():
	for spawn in bullet_spawn_ring.get_children():
		# copypaste from Lelito's code
		var bullet = bulletScene.instantiate()
		bullet.spawn(spawn.global_position, self)


func _process(delta: float) -> void:
	shootTimer += delta
	if(shootTimer >= shootTimeLimit):
		shoot()
		shootTimer = 0
