class_name PlayerShip extends CharacterBody2D

@export var rotation_speed = 5.0
@export var max_move_speed = 300.0
@export var accel_speed = 15.0
@export var arial_friction = 0.95
@export var fire_rate = 0.35
@export var bullet_speed = 800.0
@export var max_fuel = 30.0
@export var max_ammo = 20
@onready var bullet_scene = preload("res://scenes/bullet.tscn")

var _velocity: Vector2 
var direction: Vector2
var can_fire = true
var fuel = max_fuel
var ammo = max_ammo
var can_shop = false

signal fuel_consumed(current_fuel, max_fuel)
signal ammo_changed(ammo)
signal open_shop()

func _ready():
	fuel_consumed.emit(fuel, max_fuel)
	ammo_changed.emit(ammo)
	open_shop.connect(get_parent()._on_open_shop)

func _process(delta):
	handle_movement(delta)
	handle_attack(delta)
	
	if Input.is_action_just_pressed("OpenShop"):
		open_shop.emit()
	
	
func handle_movement(delta):
	if Input.is_action_pressed("TurnLeft"):
		rotation -= rotation_speed*delta
	if Input.is_action_pressed("TurnRight"):
		rotation += rotation_speed*delta
	
	direction = Vector2(0, -1).rotated(rotation).normalized()
	
	if Input.is_action_pressed("MoveForward"):
		if(fuel >= 0):
			fuel-=delta
			fuel_consumed.emit(fuel, max_fuel)
			_velocity+=direction*accel_speed
	else:
		_velocity*= arial_friction
		
	if _velocity.length() > max_move_speed: #Caps _velocity to maximium movespeed.
		_velocity = _velocity.normalized()*max_move_speed

	global_position += _velocity*delta

func handle_attack(delta):
	if Input.is_action_pressed("Fire") and can_fire and ammo > 0:
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.rotation = rotation
		bullet.speed = bullet_speed
		bullet.global_position = global_position
		bullet.z_index = z_index-1
		can_fire = false
		$AttackTimer.wait_time = fire_rate
		$AttackTimer.start()
		ammo -= 1
		ammo_changed.emit(ammo)

func _on_attack_timer_timeout():
	can_fire = true
	
func reload_ammo():
	ammo = max_ammo
	ammo_changed.emit(ammo)
