extends RigidBody2D

@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")

var size = 1
@export var initial_velocity:Vector2
# Called when the node enters the scene tree for the first time.
func _ready():
	apply_impulse(initial_velocity)
	contact_monitor = true
	max_contacts_reported = 1
	mass = size
	$Sprite2D.scale *= size
	$CollisionShape2D.scale *= size




func _on_body_entered(body):
	if body is Player:
		body.queue_free()
		queue_free()


func _on_tree_exiting():
	if size > 1:
		for i in 2:
			var asteroid = asteroid_scene.instantiate()
			asteroid.global_position = global_position + Vector2.UP.rotated(deg_to_rad(randf_range(0,360))) * 20 * size
			#asteroid.global_position = global_position 
			#asteroid.initial_velocity = Vector2.RIGHT.rotated(angle) * 100
			asteroid.initial_velocity = linear_velocity + Vector2.RIGHT.rotated(deg_to_rad(randf_range(0,360))) * randf_range(1,150)
			asteroid.size = size - 1
			get_parent().add_child.call_deferred(asteroid)
