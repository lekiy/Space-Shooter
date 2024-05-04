extends Node2D

@onready var player_scene = preload("res://scenes/player_ship.tscn")
@onready var asteroid_scene = preload("res://scenes/asteroid.tscn")
@onready var view_center = $Camera.global_position
@onready var game_over_label = $"HUD/GameOverLabel"
@onready var game_start_label = $HUD/GameStartLabel

@export var lives := 2


var score := 0
var game_started = false
var spawn_count = 1.0
var max_spawn_count = 10

signal lives_changed(lives)
signal score_updated(score)

func _process(_delta):
	if Input.is_action_just_pressed("Restart"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("Fire") and not game_started :
		game_started = true
		spawn_player()
		lives_changed.emit(lives)
		game_start_label.visible = false
		

func _on_asteroid_spawn_timer_timeout():
	for i in floor(spawn_count):
		var asteroid = asteroid_scene.instantiate()
		asteroid.global_position = view_center+Vector2.ONE.rotated(deg_to_rad(randf_range(0, 360))).normalized()*view_center.distance_to(global_position)
		var angle = asteroid.get_angle_to(view_center)
		asteroid.initial_velocity = Vector2(1, 0).rotated(randf_range(angle-deg_to_rad(30), angle+deg_to_rad(30))).normalized()*randf_range(50, 150)
		add_child(asteroid)
		spawn_count+=0.1
	if(spawn_count > max_spawn_count and game_started):
		spawn_count = max_spawn_count
	
func spawn_player():
	var new_player = player_scene.instantiate()
	add_child.call_deferred(new_player)
	new_player.position = view_center
	new_player.tree_exiting.connect(on_player_death)

func on_player_death():
	if lives > 0 :
		lives-=1
		lives_changed.emit(lives)
		await get_tree().create_timer(2.0).timeout
		spawn_player()
	elif lives == 0:
		await get_tree().create_timer(2.0).timeout
		game_over_label.text = "Game over
		final score:
			"+str(score)+"
			press R to restart"
		game_over_label.visible = true
		$GameOverSound.play()

func add_score(_score):
	score += _score
	score_updated.emit(score)


func _on_game_area_body_exited(body):
	body.queue_free()


func _on_timer_timeout():
	if not game_started:
		game_start_label.visible = !game_start_label.visible
