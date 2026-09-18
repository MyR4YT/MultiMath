extends StaticBody2D

enum Operacao { SOMA, SUBTRACAO, MULTIPLICACAO, DIVISAO }
enum Faltante { PRIMEIRO, SEGUNDO, RESULTADO }

var numbers = 0

@export var num1: int      # Primeiro operando
@export var num2: int      # Segundo operando
@export var id: int
@export var operacao: Operacao = Operacao.SOMA
@export var faltante: Faltante = Faltante.SEGUNDO

var cu = true


func _ready() -> void:
	$"Label2".text = _montar_equacao()


func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.clones.is_empty() and cu:
		cu = false
		for i in body.clones:
			addnum()
			i.queue_free()
			await get_tree().create_timer(0.3).timeout
		body.clones.clear()
		cu = true


func addnum() -> void:
	var tween = create_tween()
	var pos = $Label2.position.y
	tween.tween_property($"Label2", "position:y", pos - 10, 0.1)
	numbers += 1
	$"Label2".text = _montar_equacao()
	tween.tween_property($"Label2", "position:y", pos, 0.1)
	if numbers == _valor_esperado():
		Global.active = id
		print(id)


func _simbolo() -> String:
	match operacao:
		Operacao.SOMA:
			return "+"
		Operacao.SUBTRACAO:
			return "-"
		Operacao.MULTIPLICACAO:
			return "x"
		Operacao.DIVISAO:
			return "÷"
	return "?"


# Valor que o número faltante deve ter para a conta bater
# Valor que o número faltante deve ter para a conta bater
func _valor_esperado() -> int:
	match faltante:
		Faltante.PRIMEIRO:
			match operacao:
				Operacao.SOMA:
					return num1 - num2 # Ex: ? + 3 = 6 -> ? = 6 - 3 = 3
				Operacao.SUBTRACAO:
					return num1 + num2 # Ex: ? - 3 = 6 -> ? = 6 + 3 = 9
				Operacao.MULTIPLICACAO:
					return 0 if num2 == 0 else num1 / num2 # Ex: ? * 3 = 6 -> ? = 6 / 3 = 2
				Operacao.DIVISAO:
					return num1 * num2 # Ex: ? / 3 = 6 -> ? = 6 * 3 = 18
		Faltante.SEGUNDO:
			match operacao:
				Operacao.SOMA:
					return num2 - num1 # Ex: 3 + ? = 6 -> ? = 6 - 3 = 3
				Operacao.SUBTRACAO:
					return num1 - num2 # Ex: 6 - ? = 3 -> ? = 6 - 3 = 3
				Operacao.MULTIPLICACAO:
					return 0 if num1 == 0 else num2 / num1
				Operacao.DIVISAO:
					return 0 if num2 == 0 else num1 / num2
		Faltante.RESULTADO:
			match operacao:
				Operacao.SOMA:
					return num1 + num2
				Operacao.SUBTRACAO:
					return num1 - num2
				Operacao.MULTIPLICACAO:
					return num1 * num2
				Operacao.DIVISAO:
					return 0 if num2 == 0 else num1 / num2
	return 0


func _montar_equacao() -> String:
	match faltante:
		Faltante.PRIMEIRO:
			return "? " + _simbolo() + " " + str(num2) + " = " + str(num1)
		Faltante.SEGUNDO:
			return str(num1) + " " + _simbolo() + " ? = " + str(num2)
		Faltante.RESULTADO:
			return str(num1) + " " + _simbolo() + " " + str(num2) + " = ?"
	return "?"
