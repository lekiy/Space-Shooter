extends Node2D

@onready var player_scene = preload("res://scenes/player_ship.tscn")
@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")
@onready var view_center = $Camera.global_position
@export var lives := 3

const SHOP_GUI_SCENE = preload("res://scenes/shop_gui.tscn")

var score := 0

signal lives_changed(lives)
signal score_updated(score)

func _ready():
	spawn_player()
	lives_changed.emit(lives)

func _on_asteroid_spawn_timer_timeout():
	var asteroid = asteroid_scene.instantiate()
	asteroid.global_position = view_center+Vector2.ONE.rotated(deg_to_rad(randf_range(0, 360))).normalized()*view_center.distance_to(global_position)
	var angle = asteroid.get_angle_to(view_center)
	asteroid.initial_velocity = Vector2(1, 0).rotated(randf_range(angle-deg_to_rad(30), angle+deg_to_rad(30))).normalized()*randf_range(50, 200)
	add_child(asteroid)
	
func spawn_player():
	var new_player = player_scene.instantiate()
	add_child.call_deferred(new_player)
	new_player.tree_exiting.connect(on_player_death)
	new_player.fuel_consumed.connect($HUD/FuelBar.on_player_fuel_consumed)
	new_player.ammo_changed.connect($HUD/BulletsContainer._on_value_changed)

func on_player_death():
	if lives > 0 :
		lives-=1
		lives_changed.emit(lives)
		spawn_player()
		

func add_score(_score):
	score += _score
	score_updated.emit(score)

func _on_game_area_body_exited(body):
	body.queue_free()


func _on_open_shop():
	var shop = SHOP_GUI_SCENE.instantiate()
	shop.position = view_center
	add_child(shop)
	get_tree().paused = true
