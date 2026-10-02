extends Control

var item = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		item += 1
		item = clamp(item, 1, 3)
		
	elif event.is_action_pressed("ui_up"):
		item -= 1
		item = clamp(item, 1, 3)
		
	elif event.is_action_pressed("ui_accept"):
		if item == 1:
			get_tree().change_scene_to_file("res://Cenas/Fase 1-2.tscn")
		elif item == 3:
			get_tree().quit()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if item == 1:
		$Play.text = "[wave][color=blue]Play"
		$Play2.text = "Options"
		$Play3.text = "Exit"
	elif item == 2:
		$Play2.text = "[wave][color=blue]Options"
		$Play.text = "Play"
		$Play3.text = "Exit"
	elif item == 3:
		$Play3.text = "[wave][color=blue]Exit"
		$Play.text = "Play"
		$Play2.text = "Options"


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Cenas/Fase 1-2.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
