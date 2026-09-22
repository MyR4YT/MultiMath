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
	GameManager.dead(player.global_position, marker_2d.global_position)
