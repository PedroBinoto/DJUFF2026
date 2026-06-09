class_name PlayerDashEffect
extends Sprite3D

func _ready() -> void:
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	offset = Vector2(0, 4)
	modulate = Color(0.5, 1, 1, 1) * Color(1, 1, 1, 0.5)
	
	var life_tween = get_tree().create_tween()
	life_tween.tween_property(self, "modulate", Color(0.5, 1, 1, 1) * Color(1, 1, 1, 0), 0.5)
	await life_tween.finished
	queue_free()
