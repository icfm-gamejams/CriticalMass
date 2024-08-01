extends Area2D

signal critical_mass_achieved

@export var fragment_scene: PackedScene
var main_scene: Node
var consumer_size: float = 0
var consumer_max_size: float = 0;
var growth_rate: float = 0.5
var critical_mass: float = 5
var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var border: float = 10432
var input_available: bool = true
var motion_available: bool = true

func _ready():
	consumer_max_size = randf() + 0.5
	consumer_size = consumer_max_size
	$Sprite2D.scale = Vector2(consumer_size, consumer_size)
	$CollisionShape2D.scale = Vector2(consumer_size, consumer_size)

func _process(delta):
	if motion_available:
		velocity += acceleration * delta
		position += velocity * delta
	
	rotate(deg_to_rad(50 * delta * (1 / consumer_size)))
	
	if consumer_size < consumer_max_size:
		consumer_size += growth_rate * delta
		$Sprite2D.scale = Vector2(consumer_size, consumer_size)
		$CollisionShape2D.scale = Vector2(consumer_size, consumer_size)

func consume(area):
	var consumed = false
	if area.is_in_group("consumers"):
		if not self.is_in_group("critical_mass") and (area.consumer_size > consumer_size or area.is_in_group("critical_mass")):
			consumed = true
			var direction_vector : Vector2 = (position - area.position).normalized()
			var offset = 45
			for i in range(0, 4):
				var fragment = fragment_scene.instantiate()
				fragment.velocity = direction_vector.rotated(deg_to_rad(offset)) * randf_range(2000, 2500)
				offset -= 22.5
				fragment.size = consumer_size
				fragment.target = area
				fragment.position = position
				main_scene.add_child(fragment)
	elif area.is_in_group("fragments"):
		consumer_max_size += area.size / 4
		if consumer_max_size >= critical_mass:
			critical_mass_achieved.emit(self)
	
	return consumed
