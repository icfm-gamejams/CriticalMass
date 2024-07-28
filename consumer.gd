extends Area2D

@export var fragment_scene: PackedScene
var main_scene: Node
var consumer_size = 0
var consumer_max_size = 0;
var growth_rate = 0.5
var critical_mass = 20

func _ready():
	consumer_max_size = randf() + 0.5
	consumer_size = consumer_max_size
	$Sprite2D.scale = Vector2(consumer_size, consumer_size)
	$CollisionShape2D.scale = Vector2(consumer_size, consumer_size)

func _process(delta):
	pass
	#var asteroids = main_scene.get_node("MobContainer").get_children()
	#asteroids.push_back(main_scene.get_node("Player"))
	#for mob in asteroids:
		#if mob != self:
			#var f = (10 * consumer_size * mob.consumer_size) / position.distance_squared_to(mob.position)
			#mob.velocity += f * delta * (position - mob.position).normalized()

func grow(delta):
	if consumer_size < consumer_max_size:
		consumer_size += growth_rate * delta
		$Sprite2D.scale = Vector2(consumer_size, consumer_size)
		$CollisionShape2D.scale = Vector2(consumer_size, consumer_size)

func consume(area):
	var consumed = false
	if area.is_in_group("mobs") or area.is_in_group("player"):
		if area.consumer_size > consumer_size:
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
	
	return consumed
