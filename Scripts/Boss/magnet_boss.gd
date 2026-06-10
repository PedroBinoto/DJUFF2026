class_name MagnetBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null
@onready var player: Player = $"../Player"
@export var shootTimeLimit = 5
@export var movePercent = 0.5
@onready var bulletScene = preload("res://Scenes/bullet_dual.tscn")
@onready var left_hand: Node3D = $Body/Hand_L
@onready var right_hand: Node3D = $Body/Hand_R


var shootTimer = 0
var moveSpeed = 1
var hand_origin = []
var hand_attacking = false

enum polo{
	POSITIVO, NEGATIVO
}
var currentPolo: polo = polo.POSITIVO

func _ready() -> void:
	moveSpeed = player.playerSpeed*movePercent
	hand_origin = [left_hand.global_position, right_hand.global_position]
	
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 50 * delta
	move_and_slide()

func _process(delta: float) -> void:
	shootTimer += delta

	if shootTimer >= shootTimeLimit:
		shootTimer = 0
		_hand_attack()
		_shoot()
		_move_player()

func _shoot() -> void:
	if player == null:
		return
	for spawn in $BulletSpawn.get_children():
		var bullet = bulletScene.instantiate()
		var dir3d = player.global_position - global_position
		bullet.moveDirection = Vector2(dir3d.x,dir3d.z).normalized()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = spawn.global_position
	
func _move_player() -> void:
	for i in range(60):
		var dir
		if currentPolo == polo.POSITIVO:
			dir = 1
		else:
			dir = -1
		var direction = (global_position - player.global_position).normalized()
		player.velocity_modifier += dir * direction * 2
		await get_tree().create_timer(0.05).timeout
	
func _switchPolo():
	if currentPolo == polo.POSITIVO:
		currentPolo = polo.NEGATIVO
	else:
		currentPolo = polo.POSITIVO

func _hand_attack():
	if hand_attacking:
		return

	hand_attacking = true

	var i = randi_range(0, 1)
	var hand
	var offset = Vector3(-1, 0, 0)
	if i == 0:
		hand = left_hand 
		offset.z = 2.5
	else:
		hand = right_hand
		offset.z = -2.5
	hand.target_position = player.global_position + offset
	hand.target_position.y = hand_origin[i].y
	hand.attacking = true
	while hand.global_position.distance_to(hand.target_position) > 0.5:
		await get_tree().process_frame

	hand.target_position = hand_origin[i]

	while hand.global_position.distance_to(hand_origin[i]) > 0.5:
		await get_tree().process_frame

	hand.global_position = hand_origin[i]
	hand.attacking = false

	hand_attacking = false
	
func die() -> void:
	print("Uogh")
	pass
