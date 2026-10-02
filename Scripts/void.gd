extends Area2D

@onready var player: CharacterBody2D = $"../../Player"
@onready var marker_2d: Marker2D = $Marker2D
@onready var transition: AnimationPlayer = $"../../CanvasLayer/Transition/AnimationPlayer"
@onready var transition2: CanvasLayer = $"../../CanvasLayer/Transition"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.death_alterada.connect(die)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		transition2.show()
		transition.play("fade_out")
		await transition.animation_finished
		GameManager.dead(body.global_position, marker_2d.global_position)
		
func die(valor) -> void:
	if valor == false: return
	transition2.show()
	transition.play("fade_out")
	await transition.animation_finished
	if Global.active == 1:
		GameManager.dead(player.global_position, $Marker2D.global_position)
	elif Global.active == 2:
		GameManager.dead(player.global_position, $"../Void 2/Marker2D".global_position)
	elif Global.active == 3:
		GameManager.dead(player.global_position, $"../Void 3/Marker2D".global_position)
	elif Global.active == 4:
		GameManager.dead(player.global_position, $"../Void 4/Marker2D".global_position)
	elif Global.active == 5:
		GameManager.dead(player.global_position, $"../Void 5/Marker2D".global_position)
	elif Global.active == 6:
		GameManager.dead(player.global_position, $"../Void 6/Marker2D".global_position)
	elif Global.active == 7:
		GameManager.dead(player.global_position, $"../Void 7/Marker2D".global_position)
