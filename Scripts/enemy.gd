extends Area2D

var direcao: Vector2
@onready var player: CharacterBody2D = $"../Player"
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


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if Global.active == 1:
			print(Global.active)
			GameManager.dead(player.global_position, $"../Node2D3/Void 1/Marker2D".global_position)
		elif Global.active == 2:
			GameManager.dead(player.global_position, $"../Node2D3/Void 2/Marker2D".global_position)
		elif Global.active == 3:
			GameManager.dead(player.global_position, $"../Node2D3/Void 3/Marker2D".global_position)
		elif Global.active == 4:
			GameManager.dead(player.global_position, $"../Node2D3/Void 4/Marker2D".global_position)
		elif Global.active == 5:
			GameManager.dead(player.global_position, $"../Node2D3/Void 5/Marker2D".global_position)
		elif Global.active == 6:
			GameManager.dead(player.global_position, $"../Node2D3/Void 6/Marker2D".global_position)
		elif Global.active == 7:
			GameManager.dead(player.global_position, $"../Node2D3/Void 7/Marker2D".global_position)
		else:
			print("err")
			GameManager.dead(player.global_position, $"../Node2D3/Void 1/Marker2D".global_position)
