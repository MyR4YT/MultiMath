extends StaticBody2D

var numbers = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"../Label2".text = str(numbers) + "/1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.clones.is_empty():
		for i in body.clones:
			numbers += 1
			$"../Label2".text = str(numbers) + "/1"
			i.queue_free()
		body.clones.clear()
