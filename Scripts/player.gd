class_name Player
extends CharacterBody3D

# TODO 8 DIREÇÕES

@export_group("Components")
@export var healthComponent: HealthComponent = null

@export_group("Settings")
@export var playerSpeed: float = 300

@onready var attack_cooldown: Timer = %AttackCooldown
@onready var ranged_spawn_location: Marker3D = %RangedSpawnLocation
@onready var attack_pivot: Node3D = %AttackPivot
@onready var physical_attack_area: Area3D = %PhysicalAttackArea

@onready var bulletScene = preload("uid://dvow7fmekkx26")

enum playerStates {
	IDLE, WALK, GRACE
}
var currentState: playerStates = playerStates.IDLE

var canAttack: bool = true
var canMove: bool = true

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

var lastDirection: Array[Vector2] = []

func _handle_movement(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_down", "move_up", "move_left", "move_right")
	# direction = direction.rotated(-PI / 4)
	
	var movement = direction * playerSpeed * delta
	velocity = Vector3(movement.x, 0, movement.y)
	
	if velocity == Vector3.ZERO:
		currentState = playerStates.IDLE
	else:
		currentState = playerStates.WALK
		attack_pivot.rotation = Vector3(0, -Vector2.LEFT.angle_to(lastDirection[-1]), 0)
	move_and_slide()

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton:
		if canAttack:
			if event.is_action_pressed("attack_a"):
				_handle_attack(true)
			if event.is_action_pressed("attack_b"):
				_handle_attack(false)
		
		if canMove:
			if event.is_action_pressed("move_up"):
				lastDirection.append(Vector2.RIGHT)
			elif event.is_action_released("move_up"):
				lastDirection.erase(Vector2.RIGHT)
			if event.is_action_pressed("move_down"):
				lastDirection.append(Vector2.LEFT)
			elif event.is_action_released("move_down"):
				lastDirection.erase(Vector2.LEFT)
			if event.is_action_pressed("move_left"):
				lastDirection.append(Vector2.UP)
			elif event.is_action_released("move_left"):
				lastDirection.erase(Vector2.UP)
			if event.is_action_pressed("move_right"):
				lastDirection.append(Vector2.DOWN)
			elif event.is_action_released("move_right"):
				lastDirection.erase(Vector2.DOWN)

func _handle_attack(attackType: bool) -> void:
	canAttack = false
	attack_cooldown.start()
	
	if attackType: 	# Is physical attack
		print("Attack Physical!")
		physical_attack_area.monitoring = true
		await get_tree().create_timer(0.15).timeout
		physical_attack_area.monitoring = false
	else:			 # Is ranged attack
		var bullet = bulletScene.instantiate()
		if lastDirection.is_empty():
			var moveDir3D = global_position - ranged_spawn_location.global_position
			var moveDir = Vector2(moveDir3D.x, moveDir3D.z).normalized()
			bullet.moveDirection = -Vector2i(moveDir.normalized())
		else:
			bullet.moveDirection = Vector2i(lastDirection[-1])
		get_tree().root.add_child(bullet)
		bullet.global_position = ranged_spawn_location.global_position
	
	
	await attack_cooldown.timeout
	canAttack = true

func die() -> void:
	print("Health Depleted!")


func _attack_body(body: Node3D) -> void:
	print("Entity Detected Within Range!")
