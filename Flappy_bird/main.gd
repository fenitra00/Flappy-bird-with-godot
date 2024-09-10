extends Node2D

@export var pipe_scene : PackedScene

var game_running : bool
var game_over : bool
var scroll
var score
const SCROLL_SPEED : int = 4
var screen_size : Vector2i
var ground_height : int
var pipes : Array
const PIPE_DELAY : int = 100
const PIPE_RANGE : int = 200

# Called when the node enters the scene tree for the first time.
func _ready() :
	screen_size = get_window().size
	ground_height = $ground.get_node("Sprite2D").texture.get_height()
	new_game()
	
func new_game():
	game_running = false
	game_over = false
	score = 0
	scroll = 0
	$score.text = "SCORE: " + str(score)
	$Game_over.hide()
	get_tree().call_group("pipes", "free")
	pipes.clear()
	
	generate_pipes()
	$bird.reset()
	
func _input(event: InputEvent):
	if game_over == false:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				if game_running == false :
					start_game()
				else:
					if $bird.flying:
						$bird.flap()
						check_top()
						
					 # Replace with function body.
func start_game():
	game_running = true
	$bird.flying = true
	$background.fram = true;
	$bird.flap()
	
	$pipeTimer.start()
	
func _process(delta):
	if game_running:
		scroll += SCROLL_SPEED
		
		if scroll >= screen_size.x:
			scroll = 0
			
		$ground.position.x = -scroll
		
		for pipe in pipes:
			pipe.position.x -= SCROLL_SPEED


func _on_pipe_timer_timeout() -> void:
	generate_pipes() # Replace with function body.
	
func generate_pipes():
	var pipe = pipe_scene.instantiate()
	pipe.position.x = screen_size.x + PIPE_DELAY
	pipe.position.y = (screen_size.y - ground_height) / 2 + randi_range(-PIPE_RANGE, PIPE_RANGE)
	pipe.hit.connect(bird_hit)
	pipe.scored.connect(scored)
	add_child(pipe)
	pipes.append(pipe)
	
func scored():
	score += 1
	$score.text = "SCORE: " + str(score)
	
func check_top():
	if $bird.position.y < 0:
		$bird.falling = true
		stop_game()
	
func bird_hit():
	$bird.falling = true
	stop_game()
	
func _on_ground_hit():
	$bird.falling = false
	stop_game() # Replace with function body.

func stop_game():
	$pipeTimer.stop()
	$Game_over.show()
	$background.fram = false;
	$bird.flying = false
	game_running = false
	game_over = true


func _on_game_over_restart() -> void:
	new_game()


	
