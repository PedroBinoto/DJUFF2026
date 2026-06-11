class_name MagnetBoss
extends CharacterBody3D

@export var healthComponent: HealthComponent = null
@onready var player: Player = $"../Player"
@export var shootTimeLimit = 1.5
@export var movePercent = 0.5
@onready var bulletScene = preload("res://Scenes/bullet_dual.tscn")
@onready var left_hand: Node3D = $Body/Hand_L
@onready var right_hand: Node3D = $Body/Hand_R
@onready var boxes: Node3D = $"../Boxes"
@onready var body: Node3D = $Body

@onready var dual_shot_sfx: AudioStreamPlayer = $SFX/dualShotSFX
@onready var magnetims_sfx: AudioStreamPlayer = $SFX/magnetimsSFX
@onready var collision_sfx: AudioStreamPlayer = $SFX/collisionSFX


var shootTimer = 0
var moveSpeed = 1
var hand_origin = []
var hand_attacking = false
var magnet_active = false
var box_locked = false

var timer = 0;

enum Attacks{
	SHOOT,
	MAGNET,
	HAND,
	BOX,
	SWITCH
}

var attack_history = []
var body_origin

enum polo{
	POSITIVO, NEGATIVO
}
var currentPolo: polo = polo.POSITIVO


func _ready() -> void:
	moveSpeed = player.playerSpeed*movePercent
	hand_origin = [left_hand.position, right_hand.position]
	body_origin = body.position


func _physics_process(delta: float) -> void:
	timer += delta
	velocity = 4*Vector3(-2*sin(timer), 0, cos(timer)-2.3*cos(2.3*timer))
	if !is_on_floor():
		velocity.y -= 50 * delta
		
	move_and_slide()

var changingSide := false

func _process(delta: float) -> void:
	if !changingSide:
		shootTimer += delta

	if shootTimer >= shootTimeLimit:
		shootTimer = 0
		use_attack()


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
	if magnet_active:
		return
	magnet_active = true
	for i in range(50):
		var dir
		if currentPolo == polo.POSITIVO:
			dir = 1
		else:
			dir = -1
		var direction = (global_position - player.global_position).normalized()
		player.velocity_modifier += dir * direction
		await get_tree().create_timer(0.05).timeout
	magnet_active = false
	

@onready var head: AnimatedSprite3D = %Head
@onready var torso: AnimatedSprite3D = %Torso
@onready var hand_left: AnimatedSprite3D = %Hand_Left
@onready var hand_right: AnimatedSprite3D = %Hand_Right

## RED = POS
## BLUE = NEG

func _switchPolo():
	changingSide = true
	var leftHandPos = hand_left.position
	var leftHandTween = create_tween()
	leftHandTween.tween_property(hand_left, "position", Vector3(hand_left.position.x, hand_left.position.y, 0), 0.3)
	var rightHandPos = hand_right.position
	var rightHandTween = create_tween()
	rightHandTween.tween_property(hand_right, "position", Vector3(hand_right.position.x, hand_right.position.y, 0), 0.3)
	
	if currentPolo == polo.POSITIVO:
		currentPolo = polo.NEGATIVO
		
		torso.play("before_rtb")
		torso.position.y += 1
		await torso.animation_finished
		torso.play("red_to_blue")
		await torso.animation_finished
		torso.play("after_rtb")
		await torso.animation_finished
		torso.position.y -= 1
		torso.play("default")
		torso.pause()
		torso.frame = 0
		hand_left.frame = 0
		hand_right.frame = 0
		leftHandTween = create_tween()
		leftHandTween.tween_property(hand_left, "position", leftHandPos, 0.3)
		rightHandTween = create_tween()
		rightHandTween.tween_property(hand_right, "position", rightHandPos, 0.3)
		head.play("rtb")
		await head.animation_finished
		head.play("default")
		head.pause()
		head.frame = 0
	else:
		currentPolo = polo.POSITIVO
		
		torso.play("before_btr")
		torso.position.y += 1
		await torso.animation_finished
		torso.play("blue_to_red")
		await torso.animation_finished
		torso.play("after_btr")
		await torso.animation_finished
		torso.position.y -= 1
		torso.play("default")
		torso.pause()
		torso.frame = 1
		hand_left.frame = 1
		hand_right.frame = 1
		leftHandTween = create_tween()
		leftHandTween.tween_property(hand_left, "position", leftHandPos, 0.3)
		rightHandTween = create_tween()
		rightHandTween.tween_property(hand_right, "position", rightHandPos, 0.3)
		head.play("btr")
		await head.animation_finished
		head.play("default")
		head.pause()
		head.frame = 1
	
	print("polo trocado")
	changingSide = false
	
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
		
	var predicted_position = player.global_position + player.velocity.normalized() * 3
	var target = predicted_position + offset
	target.y = hand_origin[i].y
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(hand, "global_position", target, 0.5)
	await tween.finished
	
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(hand, "position", hand_origin[i], 0.5)
	await tween.finished

	hand_attacking = false
	
	
func die() -> void:
	print("Uogh")
	pass


func _box_attack():
	var chosen_boxes = boxes.get_children()
	chosen_boxes.shuffle()
	chosen_boxes = chosen_boxes.slice(0, 3)
	for caixa in chosen_boxes:
		var target_position
		if currentPolo == polo.POSITIVO:
			target_position = global_position
		else:
			target_position = player.global_position
		target_position.y = caixa.global_position.y
		var direction = (target_position - caixa.global_position).normalized()
		
		caixa.target_position = target_position
		caixa.moving = true
		caixa.linear_velocity = direction * 15.0


func choose_attack() -> int:
	var available = [Attacks.SHOOT, Attacks.MAGNET, Attacks.HAND, Attacks.BOX, Attacks.SWITCH]
	
	if magnet_active:
		available.erase(Attacks.MAGNET)
		
	if box_locked:
		available.erase(Attacks.BOX)
	if attack_history.size() >= 2:
		var last = attack_history[-1]
		if attack_history[-2] == last or last == Attacks.SWITCH:
			available.erase(last)
			
	var attack = available.pick_random()
	attack_history.append(attack)
	
	if attack_history.size() > 2:
		attack_history.pop_front()
		
	return attack
	
	
func use_attack():
	match choose_attack():
		Attacks.SHOOT:
			dual_shot_sfx.play()
			_shoot()
		Attacks.MAGNET:
			magnetims_sfx.play()
			_move_player()
		Attacks.HAND:
			_hand_attack()
		Attacks.BOX:
			magnetims_sfx.play()
			box_locked = true
			_box_attack()
		Attacks.SWITCH:
			box_locked = false
			_switchPolo()		
