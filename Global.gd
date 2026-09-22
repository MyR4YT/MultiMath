extends Node

signal death_alterada(valor)

var coins = 0
var active = 0
var death = false:
	set(valor):
		death = valor
		death_alterada.emit(valor)
var body = Vector2(-1072.0, 584.0)
