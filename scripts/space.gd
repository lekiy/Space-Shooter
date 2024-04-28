extends Node2D

@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")
@onready var center_position:Vector2 =$Camera2D.position

func _on_asteroid_spawn_timer_timeout():
	var asteroid = asteroid_scene.instantiate()
	asteroid.global_position = center_position + Vector2.UP.rotated(deg_to_rad(randf_range(0,360))) * 800
	var angle = asteroid.get_angle_to(center_position)
	#asteroid.initial_velocity = Vector2.RIGHT.rotated(angle) * 100
	asteroid.initial_velocity = Vector2.RIGHT.rotated(angle + deg_to_rad(randf_range(0,30))) * randf_range(100,300) 
	asteroid.size = randi_range(1,5)
	
	add_child(asteroid)
	

