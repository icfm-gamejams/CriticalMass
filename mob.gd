extends "consumer.gd"

func _process(delta):
	if input_available and position.distance_to(Vector2.ZERO) > border:
		var direction: Vector2 = position.direction_to(Vector2.ZERO)
		velocity += direction.normalized() * delta * 200
		
	super(delta)

func _on_area_entered(area):
	var consumed = consume(area)
	if consumed:
		queue_free()


func _on_sprite_2d_draw():
	$Sprite2D.material.set_shader_parameter("aura_color", Vector4(1.0, 0.0, 0.0, 1.0))
