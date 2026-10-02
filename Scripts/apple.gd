extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = create_tween().set_loops()
	tween.tween_property(self, "position:y", +16, 1).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:y", -16, 1).as_relative().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.macas += 1
		queue_free()
