extends AnimatableBody2D


func _on_area_body_entered(body):
	if body is PlayerShip:
		body.can_shop = true


func _on_area_body_exited(body):
	if body is PlayerShip:
		body.can_shop = false
