
extends Control

@onready var boss_title: Label = %BossTitle
@onready var boss_health: ProgressBar = %BossHealth
@onready var player_health: ProgressBar = $PlayerHealth


# TODO: Animação de Título/Barra de vida funcional
func _ready() -> void:
	SignalBus.updateBossStats.connect(updateBossStats)
	SignalBus.updateBossbar.connect(updateBossHealth)
	SignalBus.updatePlayerbar.connect(updatePlayerBar)

	var healthFillTween = create_tween()
	healthFillTween.tween_property(player_health, "value", player_health.max_value, 3.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)



func updateBossHealth(health: float) -> void:
	var healUpdateTween = create_tween()
	healUpdateTween.tween_property(boss_health, "value", health, (boss_health.max_value-health)/100).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	pass


func updatePlayerBar(health:float):
	var healUpdateTween = create_tween()
	healUpdateTween.tween_property(player_health, "value", health, (player_health.max_value-health)/100).set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	pass


func updateBossStats(bossName: String, maxHealth: float) -> void:
	boss_title.text = bossName
	boss_health.max_value = maxHealth
	playBarAnimation()


func playBarAnimation() -> void:
	var healthFillTween = create_tween()
	healthFillTween.tween_property(boss_health, "value", boss_health.max_value, 3.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await healthFillTween.finished
	
	var bosstitleFadeOut = create_tween()
	bosstitleFadeOut.tween_property(boss_title, "self_modulate", Color(1,1,1,0), 0.5).set_ease(Tween.EASE_OUT)
	var bossbarMove = create_tween()
	bossbarMove.tween_property(boss_health, "position", Vector2(boss_health.position.x, 32), 0.5).set_ease(Tween.EASE_OUT)
	await bosstitleFadeOut.finished
	await bossbarMove.finished
	
	await get_tree().create_timer(1).timeout
	
	boss_title.position = Vector2(boss_title.position.x, boss_health.position.y + 25)
	
	var bosstitleFadeIn = create_tween()
	bosstitleFadeIn.tween_property(boss_title, "self_modulate", Color(1,1,1,1), 0.5).set_ease(Tween.EASE_OUT)
	await bosstitleFadeIn.finished
	pass
