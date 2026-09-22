extends AudioStreamPlayer

# Lista com os caminhos das suas músicas
var playlist: Array[String] = [
	"res://Songs/WhatsApp-Audio-2026-09-01-at-09.09.40.mp3",
	"res://Songs/WhatsApp Audio 2026-09-18 at 10.53.33.mp3"
]

# Variável para controlar qual música está tocando agora
var current_track_index: int = 0

func _ready() -> void:
	# Conecta o sinal 'finished' ao nosso código (pode ser feito pelo editor também)
	self.finished.connect(_on_music_player_finished)
	
	# Começa a tocar a primeira música do jogo
	play_current_track()

func play_current_track() -> void:
	# Verifica se a playlist não está vazia para evitar erros
	if playlist.is_empty():
		return
		
	# Carrega o arquivo de áudio da música atual
	var track_path: String = playlist[current_track_index]
	var stream = load(track_path)
	
	# Define a música no player e toca
	self.stream = stream
	self.play()
	print("Tocando agora: ", track_path)

func _on_music_player_finished() -> void:
	# Avança para o próximo índice da lista
	current_track_index += 1
	
	# O SEGREDO DO LOOP: Se o índice chegar ao fim da lista, ele volta para 0
	if current_track_index >= playlist.size():
		current_track_index = 0
		
	# Toca a nova música selecionada
	play_current_track()
