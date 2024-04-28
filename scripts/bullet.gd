extends Node2D

@export var bulletSpeed = 1000
var velocity = Vector2.UP

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	global_position += velocity.rotated(rotation) * bulletSpeed * delta
	


func _on_area_2d_body_entered(body):
	body.queue_free()
	queue_free()
