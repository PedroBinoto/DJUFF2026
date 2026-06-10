class_name GhostBoss
extends CharacterBody3D


enum bodyStates {
	IDLE, WALK, GRACE
}
var currentState: bodyStates = bodyStates.IDLE


@export var healthComponent: HealthComponent = null
@export var bulletSpawnRingRadius: float = 1
@export var soulShootTimeLimit = 3
@export var bodyShootTimeLimit = 0.75
@export var movePercent = 0.4

@onready var soulBullet = preload("uid://b83onsyjngaor")
@onready var bodyBullet = preload("uid://qgqordv3giya")
@onready var bullet_spawn_ring: Node3D = $BulletSpawnRing
@onready var body_attack_pivot: Node3D = $BodyAttackPivot
@onready var body_sprite: AnimatedSprite3D = %AnimatedSprite3D
@onready var player: Player = $"../Player"

var bodyTimer = 0
var soulTimer = 0
var moveSpeed = 1

var isSeeingPlayer = false


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


func soul_shoot():
	var amountOfShots = 3
	var deltaAngle = 2*PI/bullet_spawn_ring.get_child_count()/amountOfShots
	for i in range(1,amountOfShots+1):
		for spawn in bullet_spawn_ring.get_children():
			var bullet = soulBullet.instantiate()
			bullet.bulletSpeed = 300 + i*50
			bullet.spawn(spawn.global_position, self)
		bullet_spawn_ring.rotate(Vector3(0,1,0), deltaAngle)
		await get_tree().create_timer(float(1)/float(amountOfShots)).timeout


func body_shoot():
	var bullet = bodyBullet.instantiate()
	bullet.spawn(body_attack_pivot.get_child(0).global_position, self)


func seePlayer(state:bool) -> void:
	isSeeingPlayer = state
	if isSeeingPlayer:
		movePercent = 0.5
	else:
		movePercent = 0.4
	moveSpeed = player.playerSpeed*movePercent


func _physics_process(delta: float) -> void:
	var lastVelocity = velocity
	velocity = (player.global_position - global_position).normalized()*moveSpeed*delta
	move_and_slide()
	
	var direction = velocity.normalized()
	direction = Vector3(round(direction.x),0,round(direction.z))
	body_attack_pivot.rotation = Vector3(0, sign(velocity.z)*Vector3.LEFT.angle_to(direction), 0)
	
	#copypaste from Lelito's code
	if direction == Vector3.ZERO:
		if currentState != bodyStates.IDLE:
			if lastVelocity.x > 0:
				body_sprite.play("idle_back")
			else:
				body_sprite.play("idle_front")
		currentState = bodyStates.IDLE
	else:
		currentState = bodyStates.WALK
		if direction.x > 0:
			body_sprite.play("walk_back")
		else:
			body_sprite.play("walk_front")



func _process(delta: float) -> void:
	soulTimer += delta
	if(soulTimer >= soulShootTimeLimit):
		soul_shoot()
		soulTimer = 0
	
	if(isSeeingPlayer):
		bodyTimer += delta 
		if(bodyTimer >= bodyShootTimeLimit):
			body_shoot()
			bodyTimer = 0

func die() -> void:
	print("Uogh")
