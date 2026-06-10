
extends Control

@onready var boss_title: Label = %BossTitle
@onready var boss_health: ProgressBar = %BossHealth

# TODO: Animação de Título/Barra de vida funcional
func _ready() -> void:
	SignalBus.updateBossStats.connect(updateBossStats)

func updateBossStats(name: String, maxHealth: float) -> void:
	boss_title.text = name
	boss_health.max_value = maxHealth
	playBarAnimation()

func playBarAnimation() -> void:
	var healthFillTween = create_tween()
	healthFillTween.tween_property(boss_health, "value", boss_health.max_value, 3.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await healthFillTween.finished
	var bossbarMove = create_tween()
	bossbarMove.tween_property(boss_health, "position", Vector2(boss_health.position.x, 32), 0.7).set_ease(Tween.EASE_OUT)
	pass
