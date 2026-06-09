class_name GhostBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null
@export var bulletSpawnRingRadius: float = 1
@export var shootTimeLimit = 5
@export var movePercent = 0.5

@onready var bulletScene = preload("uid://b83onsyjngaor")
@onready var bullet_spawn_ring: Node3D = $BulletSpawnRing
@onready var player: Player = $"../Player"


var shootTimer = 0
var moveSpeed = 1


func _ready():
	moveSpeed = player.playerSpeed*movePercent
	setupBulletSpawnRing()


func setupBulletSpawnRing():
	var index = 0
	var numberOfSpawns = bullet_spawn_ring.get_child_count()
	for spawn in bullet_spawn_ring.get_children():
		var angle = 2*PI/numberOfSpawns * index
		spawn.set_position(Vector3(cos(angle), 0, sin(angle)) * bulletSpawnRingRadius)
		index+=1


func _physics_process(delta: float) -> void:
	velocity = (player.global_position - global_position).normalized()*moveSpeed*delta
	if !is_on_floor():
		velocity.y -= 50 * delta
	move_and_slide()


func shoot():
	var amountOfShots = 3
	var deltaAngle = 2*PI/bullet_spawn_ring.get_child_count()/amountOfShots
	for i in range(1,amountOfShots+1):
		for spawn in bullet_spawn_ring.get_children():
			var bullet = bulletScene.instantiate()
			bullet.bulletSpeed = 300 + i*50
			bullet.spawn(spawn.global_position, self)
		bullet_spawn_ring.rotate(Vector3(0,1,0), deltaAngle)
		await get_tree().create_timer(float(1)/float(amountOfShots)).timeout


func _process(delta: float) -> void:
	shootTimer += delta
	if(shootTimer >= shootTimeLimit):
		shoot()
		shootTimer = 0
