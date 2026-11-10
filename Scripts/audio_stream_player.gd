extends AudioStreamPlayer

# Lista com os caminhos das suas músicas
var playlist: String = "res://Songs/Backrooms.mp3"

func backrooms():
	stream = load(playlist)
	self.play()
