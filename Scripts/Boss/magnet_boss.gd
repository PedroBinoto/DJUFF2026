class_name MagnetBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null
@onready var player: Player = $"../Player"
@export var shootTimeLimit = 5
@export var movePercent = 0.5
@onready var bulletScene = preload("res://Scenes/bullet_dual.tscn")

var shootTimer = 0
var moveSpeed = 1

enum polo{
	POSITIVO, NEGATIVO
}
var currentPolo: polo = polo.POSITIVO

func _ready() -> void:
	moveSpeed = player.playerSpeed*movePercent
	
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y -= 50 * delta
	move_and_slide()

func _process(delta: float) -> void:
	shootTimer += delta

	if shootTimer >= shootTimeLimit:
		shootTimer = 0
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
