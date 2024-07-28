extends Area2D

var size = 0

var acceleration = Vector2.ZERO
var velocity = Vector2.ZERO
var max_velocity = 400
var target : Node

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
	rotate(deg_to_rad(50 * delta))


func _on_area_entered(area):
	if area.is_in_group("mobs") or area.is_in_group("player"):
		queue_free()


func _on_collision_timer_timeout():
	$CollisionShape2D.set_deferred("disabled", false)
