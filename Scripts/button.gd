extends StaticBody2D

var numbers = 0

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.clones.is_empty():
		for i in body.clones:
			addnum()
			i.queue_free()
			await get_tree().create_timer(0.3).timeout
		body.clones.clear()
		
func addnum():
	var tween = create_tween()
	var pos = $"../Label2".position.y
	tween.tween_property($"../Label2", "position:y", pos -10, 0.1)
	numbers += 1
	$"../Label2".text = "2 + " +  str(numbers) + " = 4"
	tween.tween_property($"../Label2", "position:y", pos, 0.1)
