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

@onready var bulletScene = preload("uid://qgqordv3giya")

enum playerStates {
	IDLE, WALK, GRACE
}
var currentState: playerStates = playerStates.IDLE

var canAttack: bool = true
var canMove: bool = true
var canDash: bool = true
var isDashing: bool = false

func _physics_process(delta: float) -> void:
	if canMove:
		_handle_movement(delta)

var dashDirection: Vector2 = Vector2.ZERO

func _handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_down", "move_up", "move_left", "move_right")
	# direction = direction.rotated(-PI / 4)
	
	var movement = direction * playerSpeed * delta
	velocity = Vector3(movement.x, 0, movement.y)
	
	if velocity == Vector3.ZERO:
		currentState = playerStates.IDLE
	else:
		currentState = playerStates.WALK
		attack_pivot.rotation = Vector3(0, -Vector2.LEFT.angle_to(direction), 0)
	
	if isDashing:
		if dashDirection == Vector2.ZERO:
			dashDirection = direction
		var dashMovement = dashDirection * playerDashSpeed * delta
		velocity += Vector3(dashMovement.x, 0, dashMovement.y)
	else:
		dashDirection = Vector2.ZERO
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if canAttack:
			if event.is_action_pressed("attack_a"):
				_handle_attack(true)
			if event.is_action_pressed("attack_b"):
				_handle_attack(false)
		if canDash:
			if event.is_action_pressed("player_dash"):
				_handle_dash()
		if event.is_action_pressed("pause"):
			get_tree().paused = true

func _handle_attack(attackType: bool) -> void:
	if isDashing:
		return
	
	canAttack = false
	canMove = false
	
	if attackType: 	# Is physical attack
		print("Attack Physical!")
		physical_attack_area.monitoring = true
		animation_player.play("physical_swing")
		await animation_player.animation_finished
		physical_attack_area.monitoring = false
	else:			 # Is ranged attack
		var bullet = bulletScene.instantiate()
		bullet.spawn(ranged_spawn_location.global_position, self)
	
	canMove = true
	attack_cooldown.start()
	await attack_cooldown.timeout
	canAttack = true

func die() -> void:
	print("Health Depleted!")

func _handle_dash() -> void:
	canDash = false
	isDashing = true
	print("Dashed!")
	await get_tree().create_timer(0.2).timeout
	isDashing = false
	dash_cooldown.start()
	await dash_cooldown.timeout
	canDash = true

func _attack_body(body: Node3D) -> void:
	print("Entity Detected Within Range!")
