class_name Player

extends CharacterBody2D



@onready var bullet_scene = preload("res://scenes/bullet.tscn")
@export var friction = .99
@export var SPEED = 300.0
var _velocity:Vector2
@export var rotation_speed = 5
@export var fire_rate = .02
var can_fire = true

func _physics_process(delta):
	
	if Input.is_action_pressed("RotateLeft"):
		rotation -= rotation_speed * delta
	if Input.is_action_pressed("RotateRight"):
		rotation += rotation_speed * delta
		
	if Input.is_action_pressed("MoveForward"):
		_velocity = Vector2.UP * SPEED
	
	_velocity *= friction
	global_position += _velocity.rotated(rotation) * delta
	
	
func _process(delta):
	if Input.is_action_pressed("Fire") and can_fire:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.global_position = global_position
		bullet.rotation = rotation
		can_fire = false
		$AttackTimer.wait_time = fire_rate
		$AttackTimer.start()


func _on_attack_timer_timeout():
	can_fire = true
