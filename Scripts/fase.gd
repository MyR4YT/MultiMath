extends Node2D

# Referências aos Labels das opções
@onready var equation_label: RichTextLabel = $"Equação"
@onready var option_label_1: RichTextLabel = $"1"
@onready var option_label_2: RichTextLabel = $"2"
@onready var option_label_3: RichTextLabel = $"3"

# Referências aos 3 Spawners do seu jogo
@export var spawner_1: Node
@export var spawner_2: Node
@export var spawner_3: Node

# Mapeia cada Label ao seu Spawner correspondente
@onready var label_to_spawner: Dictionary = {
	option_label_1: spawner_1,
	option_label_2: spawner_2,
	option_label_3: spawner_3
}

# Configurações de jogo
var current_round: int = 1
var max_rounds: int = 5
var correct_answer: int = 0

var correct_label: RichTextLabel
var wrong_labels: Array[RichTextLabel] = []
var round_started = false

func _ready() -> void:
	$Player.global_position = Global.body
	randomize()
	
func _process(delta: float) -> void:
	if $Player.global_position.x > 5760 and round_started == false:
		round_started = true
		start_round()

func start_round() -> void:
	if current_round > max_rounds:
		equation_label.text = "Fim do Jogo!\nObrigado por Jogar!\n Moedas: " + str(Global.coins) + "\nMaçãs: " + str(Global.macas)
		$Label2.cronometro_ativo = false
		$Label2.show()
		return
		
	# Reseta os visuais ou estados dos labels se necessário
	for label in [option_label_1, option_label_2, option_label_3]:
		label.modulate = Color.WHITE

	generate_equation()
	setup_option_labels()
	
	# Aguarda 3 segundos antes de disparar o ataque dos errados
	get_tree().create_timer(4.0).timeout.connect(_on_timer_timeout)

func generate_equation() -> void:
	var max_number: int = current_round * 10
	var num1: int = randi_range(1, max_number)
	var num2: int = randi_range(1, max_number)
	
	var operators: Array[String] = ["+"]
	if current_round >= 2: operators.append("-")
	if current_round >= 4: operators.append("*")
		
	var op: String = operators.pick_random()
	
	match op:
		"+":
			correct_answer = num1 + num2
		"-":
			if num1 < num2:
				var temp = num1
				num1 = num2
				num2 = temp
			correct_answer = num1 - num2
		"*":
			num1 = randi_range(1, current_round * 2)
			num2 = randi_range(1, current_round * 2)
			correct_answer = num1 * num2

	equation_label.text = str(num1) + " " + op + " " + str(num2) + " = ?"

func setup_option_labels() -> void:
	var all_labels: Array[RichTextLabel] = [option_label_1, option_label_2, option_label_3]
	all_labels.shuffle()
	
	correct_label = all_labels.pop_back()
	wrong_labels = all_labels
	
	correct_label.text = str(correct_answer)
	
	var wrong_answers: Array[int] = []
	for label in wrong_labels:
		var wrong_val: int = generate_wrong_answer(wrong_answers)
		wrong_answers.append(wrong_val)
		label.text = str(wrong_val)

func generate_wrong_answer(existing_wrongs: Array[int]) -> int:
	var wrong_val: int = 0
	while true:
		var offset: int = randi_range(-5 * current_round, 5 * current_round)
		if offset == 0: offset = 1
		wrong_val = correct_answer + offset
		
		if wrong_val != correct_answer and not existing_wrongs.has(wrong_val):
			break
	return wrong_val

func _on_timer_timeout() -> void:
	# Percorre apenas as 2 opções incorretas da rodada
	for wrong_label in wrong_labels:
		var target_spawner = label_to_spawner.get(wrong_label)
		
		if target_spawner and target_spawner.has_method("attack"):
			# Passa o id do spawner (assumindo que o spawner possui a variável 'myid')
			var spawner_id = target_spawner.get("myid")
			target_spawner.attack(spawner_id)
			
		wrong_label.modulate = Color.RED # Feedback visual opcional
		
	# Avança de rodada
	current_round += 1
	await get_tree().create_timer(1.5).timeout
	start_round()
