class_name Player
extends CharacterBody3D

@export_group("Components")
@export var healthComponent: HealthComponent = null

@export_group("Settings")
@export var playerSpeed: float = 300
@export var playerDashSpeed: float = 600

@onready var dash_cooldown: Timer = %DashCooldown

@onready var attack_cooldown: Timer = %AttackCooldown
@onready var ranged_spawn_location: Marker3D = %RangedSpawnLocation
@onready var attack_pivot: Node3D = %AttackPivot
@onready var physical_attack_area: Area3D = %PhysicalAttackArea
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var sword: Sprite3D = %Sword
@onready var animated_sprite_3d: AnimatedSprite3D = %AnimatedSprite3D
@onready var gun: Sprite3D = %Gun
@onready var spawn_dash_ghost: Timer = %SpawnDashGhost
@onready var ghosts: Node3D = %Ghosts
@onready var sword_sfx: AudioStreamPlayer = $AttackPivot/PhysicalAttackArea/Sword2
@onready var shoot_sfx: AudioStreamPlayer = $AttackPivot/CharShoot

@onready var bulletScene = preload("uid://qgqordv3giya")

enum playerStates {
	IDLE, WALK, GRACE
}
var currentState: playerStates = playerStates.IDLE

var canAttack: bool = true
var canMove: bool = true
var canDash: bool = true
var isDashing: bool = false
var velocity_modifier: Vector3 = Vector3.ZERO

var appliedForces: Dictionary[Node, Vector3]

func _process(delta: float) -> void:
	gun.flip_v = gun.global_position.z < global_position.z

func _physics_process(delta: float) -> void:
	if canMove:
		_handle_movement(delta)
	if canAttack:
		if Input.is_action_pressed("attack_b"):
			_handle_attack(false)
	if !is_on_floor():
		velocity.y -= 1000 * delta
		move_and_slide()

var dashDirection: Vector2 = Vector2.ZERO

func _handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_down", "move_up", "move_left", "move_right")
	# direction = direction.rotated(-PI / 4)
	
	var movement = direction * playerSpeed * delta
	var lastVelocity = velocity
	velocity = Vector3(movement.x, 0, movement.y) + velocity_modifier
	velocity_modifier = velocity_modifier.lerp(Vector3.ZERO, 5 * delta)
	
	if direction == Vector2.ZERO:
		if currentState != playerStates.IDLE:
			if lastVelocity.x > 0:
				animated_sprite_3d.play("idle_back")
			else:
				animated_sprite_3d.play("idle_front")
		currentState = playerStates.IDLE
	else:
		currentState = playerStates.WALK
		attack_pivot.rotation = Vector3(0, -Vector2.LEFT.angle_to(direction), 0)
		if direction.x > 0:
			animated_sprite_3d.play("walk_back")
		else:
			animated_sprite_3d.play("walk_front")
	
	if isDashing:
		if dashDirection == Vector2.ZERO:
			dashDirection = direction
		var dashMovement = dashDirection * playerDashSpeed * delta
		velocity += Vector3(dashMovement.x, 0, dashMovement.y)
	else:
		dashDirection = Vector2.ZERO
	
	for index in appliedForces:
		velocity += appliedForces[index]
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if canAttack:
			if event.is_action_pressed("attack_a"):
				_handle_attack(true)
		if canDash:
			if event.is_action_pressed("player_dash"):
				_handle_dash()
		if event.is_action_pressed("pause"):
			SignalBus.pauseGame.emit()
			get_tree().paused = true
			
func _handle_attack(attackType: bool) -> void:
	if isDashing:
		return
	
	canAttack = false
	canMove = false
	
	attack_cooldown.start()
	if attackType: 	# Is physical attack
		print("Attack Physical!")
		physical_attack_area.monitoring = true
		animation_player.play("physical_swing")
		sword_sfx.play()
		await animation_player.animation_finished
		physical_attack_area.monitoring = false
	else:			 # Is ranged attack
		var bullet = bulletScene.instantiate()
		animation_player.play("gun_shot")
		shoot_sfx.play()
		bullet.spawn(ranged_spawn_location.global_position, self)
	
	canMove = true
	await attack_cooldown.timeout
	canAttack = true

func die() -> void:
	print("Health Depleted!")

func spawn_dash_ghost_timeout() -> void:
	var ghost = PlayerDashEffect.new()
	var currentAnimation = animated_sprite_3d.animation
	var currentFrame = animated_sprite_3d.frame
	var currentFrameTexture = animated_sprite_3d.sprite_frames.get_frame_texture(currentAnimation, currentFrame)
	
	ghost.texture = currentFrameTexture
	ghosts.add_child(ghost)
	ghost.global_position = global_position
	ghost.scale = Vector3.ONE * 8

func _handle_dash() -> void:
	canDash = false
	spawn_dash_ghost.start()
	isDashing = true
	print("Dashed!")
	await get_tree().create_timer(0.25).timeout
	isDashing = false
	spawn_dash_ghost.stop()
	dash_cooldown.start()
	await dash_cooldown.timeout
	canDash = true


func _attack_body(body: Node3D) -> void:
	print("Entity Detected Within Range!")
	if "healthComponent" in body:
		print("damage!")
		body.healthComponent.damage(25)
		print(body.healthComponent.health)

func create_force(index: Node, defaultValue: Vector3) -> void:
	appliedForces[index] = defaultValue

func update_force(index: Node, value: Vector3) -> void:
	appliedForces[index] = value

func delete_force(index: Node) -> void:
	appliedForces.erase(index)
