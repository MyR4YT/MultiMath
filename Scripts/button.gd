extends StaticBody2D

var numbers = 0
@export var num1: int
@export var num2: int 
@export var id: int
var cu = true

# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _ready() -> void:
	$"Label2".text = str(num1) + " + " +  str(numbers) + " = " + str(num2)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not body.clones.is_empty() and cu:
		cu = false
		for i in body.clones:
			addnum()
			i.queue_free()
			await get_tree().create_timer(0.3).timeout
		body.clones.clear()
		cu = true
		
func addnum():
	var tween = create_tween()
	var pos = $Label2.position.y
	tween.tween_property($"Label2", "position:y", pos -10, 0.1)
	numbers += 1
	$"Label2".text = str(num1) + " + " +  str(numbers) + " = " + str(num2)
	tween.tween_property($"Label2", "position:y", pos, 0.1)
	if (num1 + numbers) == num2:
		Global.active = id
