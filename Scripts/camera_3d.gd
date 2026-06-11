extends Camera3D

@export var period = 0.3
@export var magnitude = 0.4

func _camera_shake():
	var initial_transform = self.transform 
	var elapsed_time = 0.0

	while elapsed_time < period:
		var offset = Vector3(
			0,
			randf_range(-magnitude, magnitude),
			randf_range(-magnitude, magnitude)
		)

		self.transform.origin = initial_transform.origin + offset
		elapsed_time += get_process_delta_time()
		await get_tree().create_timer(0.01).timeout

	self.transform = initial_transform
