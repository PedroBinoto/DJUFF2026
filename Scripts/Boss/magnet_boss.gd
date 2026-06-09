class_name MagnetBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null
@onready var player: Player = $"../Player"
@export var shootTimeLimit = 5
@export var movePercent = 0.5
@onready var bulletScene = preload("res://Scenes/bullet_dual.tscn")

var shootTimer = 0
var moveSpeed = 1


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

func _shoot() -> void:
	if player == null:
		return
	for spawn in $BulletSpawn.get_children():
		var bullet = bulletScene.instantiate()
		var dir3d = player.global_position - global_position
		bullet.moveDirection = Vector2(dir3d.x,dir3d.z).normalized()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = spawn.global_position
	
