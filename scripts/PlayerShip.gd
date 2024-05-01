class_name PlayerShip extends CharacterBody2D

@export var rotation_speed = 5.0
@export var max_move_speed = 300.0
@export var accel_speed = 15.0
@export var arial_friction = 0.98
@export var fire_rate = 0.25
@export var bullet_speed = 1000.0
const BULLET_SCENE = preload("res://scenes/bullet.tscn")
const EXPLOSION_PARTICLES_SCENE = preload("res://scenes/explosion_particles.tscn")

var _velocity: Vector2 
var direction: Vector2
var can_fire = true
var is_immune = true
var is_immune_timer = false

func _process(delta):
	handle_movement(delta)
	handle_attack(delta)
	
	if is_immune and not is_immune_timer:
		is_immune_timer = true
		await get_tree().create_timer(0.1).timeout
		visible = not visible
		is_immune_timer = false
	else:
		visible = true
	
func handle_movement(delta):
	if Input.is_action_pressed("TurnLeft"):
		rotation -= rotation_speed*delta
	if Input.is_action_pressed("TurnRight"):
		rotation += rotation_speed*delta
	
	direction = Vector2(0, -1).rotated(rotation).normalized()
	
	if Input.is_action_pressed("MoveForward"):
		_velocity+=direction*accel_speed
	else:
		_velocity*= arial_friction
		
	if _velocity.length() > max_move_speed: #Caps _velocity to maximium movespeed.
		_velocity = _velocity.normalized()*max_move_speed

	global_position += _velocity*delta
	
	var view_size = get_viewport_rect().size
	if global_position.x < 0:
		global_position.x += view_size.x
	elif global_position.x > view_size.x:
		global_position.x -= view_size.x
	if global_position.y < 0:
		global_position.y += view_size.y
	elif global_position.y > view_size.y:
		global_position.y -= view_size.y

func handle_attack(_delta):
	if Input.is_action_pressed("Fire") and can_fire:
		var bullet = BULLET_SCENE.instantiate()
		get_parent().add_child(bullet)
		bullet.rotation = rotation
		bullet.speed = bullet_speed
		bullet.global_position = global_position
		bullet.z_index = z_index-1
		can_fire = false
		$AttackTimer.wait_time = fire_rate
		$AttackTimer.start()
		$LaserSound.play()

func _on_attack_timer_timeout():
	can_fire = true


func _on_tree_exiting():
	var explosion = EXPLOSION_PARTICLES_SCENE.instantiate()
	get_parent().add_child.call_deferred(explosion)
	explosion.emitting = true
	explosion.global_position = global_position


func _on_immunity_timer_timeout():
	is_immune = false
