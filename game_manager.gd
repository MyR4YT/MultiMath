extends Node

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
	
func dead(body, pos) -> void:
	# Adia o recarregamento da cena para o final do frame, fora do ciclo de física
	get_tree().call_deferred("reload_current_scene")
	Global.active -= 0
	print(str(Global.active) + "test")
	Global.body = pos
