extends RigidBody2D

@export var initial_velocity : Vector2 = Vector2(0, 0)
@export var size = randi_range(1, 3)
@export var rotation_speed = randi_range(-1, 1)

@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	mass = size
	$Sprite2D.scale *= size
	$CollisionShape2D.scale *= size
	apply_impulse(initial_velocity)
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	
func _process(delta):
	$Sprite2D.rotation += rotation_speed*delta

func _on_body_entered(body):
	if(body is PlayerShip):
		body.queue_free()

func _on_tree_exiting():
	if(size > 1):
		for i in randi() % 3 + 1:
			var new_asteroid = asteroid_scene.instantiate()
			get_parent().add_child.call_deferred(new_asteroid)
			new_asteroid.size = size-1
			new_asteroid.global_position = global_position+Vector2.UP.rotated(deg_to_rad(360/(i+1)))*24
			new_asteroid.initial_velocity = linear_velocity-global_position.direction_to(new_asteroid.global_position)*50
