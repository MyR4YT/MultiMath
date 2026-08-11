extends Control

@onready var player = $"../../Player"
@onready var text = $RichTextLabel/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.SPEED > 800:
		text.text = "[wave]" + "2.5x"
	elif player.SPEED > 600:
		text.text = "[wave]" + "2x"
	elif player.SPEED > 450:
		text.text = "[wave]" + "1.75x"
	elif player.SPEED > 400:
		text.text = "[wave]" + "1.5x"
	elif player.SPEED > 350:
		text.text = "[wave]" + "1.25x"
	else:
		text.text = ""
