extends Sprite2D

var fram: bool = false
# Called when the node enters the scene tree for the first time.

func _ready():
	fram = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fram == true:
		$AnimatedSprite2D.play()
	elif fram == false:
		$AnimatedSprite2D.stop()
