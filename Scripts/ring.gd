extends Node2D

@export var radius: float = 64.0        # Distância dos fantasmas até o centro
@export var speed: float = 2.0          # Velocidade da rotação (radianos por segundo)

var boos: Array[Node] = []
var current_angle: float = 0.0

func _ready() -> void:
	# Coleta automaticamente todos os nós filhos que são fantasmas
	boos = get_children()
	update_boos_position()

func _process(delta: float) -> void:
	# Atualiza o ângulo com base no tempo e velocidade
	current_angle += speed * delta
	
	# Mantém o ângulo dentro de limites limpos (opcional, evita overflow em jogos infinitos)
	current_angle = wrapf(current_angle, -PI, PI)
	
	update_boos_position()

func update_boos_position() -> void:
	var total_boos = boos.size()
	if total_boos == 0:
		return
		
	# Divide 360 graus (2 * PI) igualmente entre a quantidade de fantasmas
	var angle_step = (2 * PI) / total_boos
	
	for i in range(total_boos):
		var boo = boos[i] as Node2D
		if boo:
			# Calcula o ângulo específico de cada fantasma na fila do anel
			var boo_angle = current_angle + (i * angle_step)
			
			# Trigonometria para posicionar em formato circular (X = cos, Y = sin)
			var offset = Vector2(cos(boo_angle), sin(boo_angle)) * radius
			boo.position = offset
			
			# Opcional: Se quiser que os fantasmas fiquem sempre virados para fora ou para o centro
			# boo.rotation = boo_angle
