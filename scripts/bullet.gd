extends Node2D

var speed = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position += Vector2(0, -1).rotated(rotation).normalized()*speed*delta


func _on_body_entered(body):
	body.queue_free()
	queue_free()
	get_parent().add_score(10)
