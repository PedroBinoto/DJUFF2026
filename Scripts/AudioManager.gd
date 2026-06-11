extends Node

func playAudio(audioFilepath: String, audioBus: String) -> void:
	var audioPlayer = AudioStreamPlayer.new()
	audioPlayer.stream = load(audioFilepath)
	audioPlayer.bus = audioBus
	get_tree().add_child(audioPlayer)
	audioPlayer.finished.connect(audioPlayer.queue_free)
	audioPlayer.play()
