extends "consumer.gd"

var velocity = Vector2.ZERO

func _process(delta):
	super(delta)
	grow(delta)
	rotate(deg_to_rad(10 * delta))
	position += velocity * delta

func _on_area_entered(area):
	var consumed = consume(area)
	if consumed:
		queue_free()
	elif consumer_max_size > critical_mass:
		main_scene.set_winner(self)
