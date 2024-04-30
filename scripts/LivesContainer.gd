extends HBoxContainer

@export var image_scene : Resource

func _on_value_changed(new_value):
	if get_child_count() != new_value:
		for child in get_children():
			child.queue_free()
		for i in new_value:
			var image = image_scene.instantiate()
			add_child(image)
