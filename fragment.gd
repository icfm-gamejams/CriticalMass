extends Area2D

var size = 0

var acceleration: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO
var max_velocity: float = 400
var target: Node

func _ready():
	$Sprite2D.scale = Vector2(size, size)
	$CollisionShape2D.scale = Vector2(size, size)

func _process(delta):
	if target != null:
		var direction : Vector2 = target.position - position
		direction = direction.normalized()
		
		acceleration = direction * 500
	else:
		queue_free()
	
	velocity += acceleration * delta
	velocity.x = clamp(velocity.x, -max_velocity, max_velocity)
	velocity.y = clamp(velocity.y, -max_velocity, max_velocity)
	position += velocity * delta
	rotate(deg_to_rad(50 * delta * (1 / size)))

func _on_area_entered(area):
	if area.is_in_group("consumers"):
		queue_free()

func _on_collision_timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)

func _on_sprite_2d_draw():
	$Sprite2D.material.set_shader_parameter("aura_color", Vector4(0.0, 1.0, 0.0, 1.0))
