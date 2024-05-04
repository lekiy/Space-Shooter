extends HBoxContainer

@onready var life_scene = preload("res://scenes/life.tscn")


func on_lives_changed(lives):
	for child in get_children():
		child.queue_free()
	for i in lives:
		var life = life_scene.instantiate()
		add_child(life)
		
