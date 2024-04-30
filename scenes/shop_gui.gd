extends Node2D


func _process(delta):
	if Input.is_action_just_pressed("OpenShop"):
		get_tree().paused = false
		queue_free()


func _on_reload_button_pressed():
	get_parent().get_node("PlayerShip").reload_ammo()
