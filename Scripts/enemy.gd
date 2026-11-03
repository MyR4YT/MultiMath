extends Area2D

var direcao: Vector2
var attack: bool = false
var velocidade: float = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	global_position += direcao * velocidade * delta
	if velocidade <= 600 and attack == true:
		velocidade += 8
	



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and attack == false:
		direcao = global_position.direction_to(body.global_position)
		$AnimatedSprite2D.play("Attack")
		attack = true
