extends Label

var tempo_decorrido: float = 0.0
var cronometro_ativo: bool = true

func _process(delta: float) -> void:
	if cronometro_ativo:
		tempo_decorrido += delta
		atualizar_texto_cronometro()

func atualizar_texto_cronometro() -> void:
	var minutos: int = int(tempo_decorrido) / 60
	var segundos: int = int(tempo_decorrido) % 60
	var milissegundos: int = int((tempo_decorrido - int(tempo_decorrido)) * 100)
	
	# Formata com 2 dígitos para minutos e segundos (ex: 02:05.42)
	text = "%02d:%02d.%02d" % [minutos, segundos, milissegundos]
