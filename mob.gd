extends "consumer.gd"

var velocity: Vector2 = Vector2.ZERO

func _process(delta):
	super(delta)
	rotate(deg_to_rad(10 * delta))
	position += velocity * delta

func _on_area_entered(area):
	var consumed = consume(area)
	if consumed:
		queue_free()


func _on_sprite_2d_draw():
	$Sprite2D.material.set_shader_parameter("aura_color", Vector4(1.0, 0.0, 0.0, 1.0))
