extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$"../CanvasLayer/UI".backrooms()
		$"../Player".global_position = Vector2(5952, 576)
		$"../AudioStreamPlayer".backrooms()
