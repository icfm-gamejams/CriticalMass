extends "consumer.gd"

signal player_consumed
signal start_game
signal critical_mass_achieved

@export var speed = 200
@export var max_velocity = 400
var velocity  = Vector2.ZERO
var border = 10432
var dead = false

func reset_size():
	consumer_max_size = 1
	consumer_size = consumer_max_size
	$Sprite2D.scale = Vector2(consumer_size, consumer_size)
	$CollisionShape2D.scale = Vector2(consumer_size, consumer_size)

func _ready():
	reset_size()
	hide()
	$Camera2D.zoom.x = 1/consumer_size
	$Camera2D.zoom.y = 1/consumer_size

func _process(delta):
	super(delta)
	if !dead:
		# update size 
		grow(delta)
		
		# update camera zoom based on size
		$Camera2D.zoom.x = 1/consumer_size
		$Camera2D.zoom.y = 1/consumer_size
		
		# get input and apply to acceleration
		var acceleration = Vector2.ZERO
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
			
		# clamp acceleration
		acceleration.x = clamp(acceleration.x, -500, 500)
		acceleration.y = clamp(acceleration.y, -500, 500)
		
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
	dead = false
	$CollisionShape2D.disabled = false

func _on_area_entered(area):
	$Explosion.play()
	var consumed = consume(area)
	if consumed:
		reset_size()
		hide()
		dead = true
		player_consumed.emit()
		velocity = Vector2.ZERO
		$CollisionShape2D.set_deferred("disabled", true)
	elif consumer_max_size > critical_mass:
		critical_mass_achieved.emit(self)

func _on_hud_start_game():
	start_game.emit()
