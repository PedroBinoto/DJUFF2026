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
@onready var bodyBullet = preload("uid://pbj02vkl5jks")
@onready var bullet_spawn_ring: Node3D = $BulletSpawnRing
@onready var body_attack_pivot: Node3D = $AttackPivot
@onready var physical_attack_area: Area3D = %PhysicalAttackArea
@onready var sword_range: Area3D = $SwordRange
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var player: Player = $"../Player"

@onready var ghost_shot_sfx: AudioStreamPlayer = $SFX/ghostShotSFX
@onready var body_shot_sfx: AudioStreamPlayer = $SFX/bodyShotSFX
@onready var body_sword_sfx: AudioStreamPlayer = $SFX/bodySwordSFX

@onready var body_sprite: AnimatedSprite3D = %AnimatedSprite3D
@onready var soul_sprite: AnimatedSprite3D = $Sprite/Soul/Head



var bodyTimer = 0
var soulTimer = 0
var moveSpeed = 1

var isSeeingPlayer = false
var isPlayerInRange = false
var isUnderLight = false
var isDead = false


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
	var amountOfShots = 1 + 4*(1-healthComponent.health_percent())
	var deltaAngle = 2*PI/bullet_spawn_ring.get_child_count()/amountOfShots
	for i in range(1,amountOfShots+1):
		ghost_shot_sfx.play()
		for spawn in bullet_spawn_ring.get_children():
			var bullet = soulBullet.instantiate()
			bullet.bulletSpeed = 300 + i*50
			bullet.spawn(spawn.global_position, self)
		bullet_spawn_ring.rotate(Vector3(0,1,0), deltaAngle)
		await get_tree().create_timer(float(1)/float(amountOfShots)).timeout


func body_shoot():
	var bullet = bodyBullet.instantiate()
	bullet.spawn(body_attack_pivot.get_child(0).global_position, self)
	animation_player.play("gun_shot")
	body_shot_sfx.play()


func body_sword():
		physical_attack_area.monitoring = true
		animation_player.play("physical_swing")
		body_sword_sfx.play()
		await animation_player.animation_finished
		physical_attack_area.monitoring = false


func _attack_body(body: Node3D) -> void:
	if body is Player:
		print("Attack body")
		body.healthComponent.damage(10)
		print(body.healthComponent.health)


func seePlayer(state:bool) -> void:
	isSeeingPlayer = state
	if isSeeingPlayer:
		movePercent = 0.5
	else:
		movePercent = 0.4
	moveSpeed = player.playerSpeed*movePercent


func _physics_process(delta: float) -> void:
	if isDead:
		return
	var lastVelocity = velocity
	var distance = player.global_position - global_position
	velocity = (distance).normalized()*moveSpeed*delta
	move_and_slide()
	
	var angle = round(distance.angle_to(Vector3.LEFT)/(PI/float(4)))*(PI/float(4))
	body_attack_pivot.rotation = Vector3(0, sign(distance.z)*angle, 0)
	var direction = Vector3(-cos(angle), 0 , sin(angle))
	
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
	if isDead:
		return
		
	soulTimer += delta
	if(!isUnderLight and soulTimer >= soulShootTimeLimit):
		soul_shoot()
		soulTimer = 0
	
	if(isSeeingPlayer):
		bodyTimer += delta
		if(bodyTimer >= bodyShootTimeLimit): 
			if isPlayerInRange:
				body_sword()
			else:
				body_shoot()
			bodyTimer = 0


func die() -> void:
	isDead = true
	
	var sprites = [body_sprite, soul_sprite]
	var tweens = []
	for sprite in sprites:
		var fadeOut = create_tween()
		tweens.append(fadeOut)
		fadeOut.tween_property(sprite, "modulate", Color(1,1,1,0), 3).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	await tweens[0].finished
	SignalBus.isGhoulstAlive = false
	get_tree().change_scene_to_file("res://Scenes/hub.tscn") # MUDAR PRO HUB


func _on_sword_range_body_entered(body: Node3D) -> void:
	if body is Player:
		isPlayerInRange = true

func _on_sword_range_body_exited(body: Node3D) -> void:
	if body is Player:
		isPlayerInRange = false
