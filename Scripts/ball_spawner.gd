extends StaticBody2D

@export var ball: PackedScene
@export var myid: int
var attacked: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func attack(id) -> void:
	if id != myid: return
	if attacked == true: return
	attacked = true
	var sceneball = ball.instantiate()
	sceneball.hide()
	sceneball.scale = Vector2(1, 1)
	add_child(sceneball)
	await get_tree().create_timer(0.1).timeout
	sceneball.show()
	sceneball.get_node("Area2D/CollisionShape2D").set_deferred("disabled", false)
	await get_tree().create_timer(1.0).timeout
	attacked = false
