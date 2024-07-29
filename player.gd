extends "consumer.gd"

signal player_consumed
signal start_game

@export var speed: float = 200
@export var max_velocity: float = 400
var velocity: Vector2  = Vector2.ZERO
var border: float = 10432

var input_available: bool = false
var motion_available: bool = false

func reset_size():
	consumer_max_size = 1
	consumer_size = consumer_max_size
	$Sprite2D.scale = Vector2(consumer_size, consumer_size)
	$CollisionShape2D.scale = Vector2(consumer_size, consumer_size)

func _ready():
	hide()
	reset_size()
	$Camera2D.zoom.x = 1 / consumer_size
	$Camera2D.zoom.y = 1 / consumer_size

func _process(delta):
	super(delta)
	
	# update camera zoom based on size
	$Camera2D.zoom.x = 1 / consumer_size
	$Camera2D.zoom.y = 1 / consumer_size
	
	var acceleration : Vector2 = Vector2.ZERO
	
	if input_available:
		# get input and apply to acceleration
		if(Input.is_action_pressed("move_right")):
			acceleration.x += 1
		if(Input.is_action_pressed("move_left")):
			acceleration.x -= 1
		if(Input.is_action_pressed("move_up")):
			acceleration.y -= 1
		if(Input.is_action_pressed("move_down")):
			acceleration.y += 1
			
		# apply speed to acceleration normal vector
		if acceleration.length() > 0:
			acceleration = acceleration.normalized() * speed
	
	if motion_available:
		# update velocity 
		velocity += acceleration * delta
		
		# clamp velocity
		velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
		velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
		
		# update position
		position += velocity * delta
		
		# clamp position
		var distance = position.distance_to(Vector2.ZERO)
		if distance > border:
			position = (position - Vector2.ZERO).normalized() * border
		
		rotate(deg_to_rad(10 * delta))

func start(pos):
	position = pos
	show()
	reset_size()
	velocity = Vector2.ZERO
	$CollisionShape2D.disabled = false
	input_available = true
	motion_available = true

func _on_area_entered(area):
	if get_tree().get_nodes_in_group("critical_mass").is_empty():
		$Explosion.play()
	var consumed: bool = consume(area)
	if consumed:
		hide()
		player_consumed.emit()
		$CollisionShape2D.set_deferred("disabled", true)
		input_available = false
		motion_available = false

func _on_hud_start_game():
	start_game.emit()

func _on_draw():
	$Sprite2D.material.set_shader_parameter("aura_color", Vector4(0.0, 0.0, 1.0, 1.0))
