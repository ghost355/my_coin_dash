extends Node

signal player_die

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var speed = 350
@export var powerup_lifetime = 3

var screensize = Vector2.ZERO
var level = 1
var time_left = 30.0
var playing = false
var score = 0

@onready var player = $Player
@onready var hud = $HUD
@onready var game_tick = $GameTick
@onready var powerup_spawn_timer = $PowerupSpawnTimer
@onready var start_button = $HUD/MarginContainer2/StartButton
@onready var message_label = $HUD/MessageLabel


func _ready() -> void:
	player.contact_with.connect(on_player_contact_with)
	game_tick.timeout.connect(_on_game_tick_timeout)

	hud.update_time(time_left)

	screensize = get_viewport().size


func _process(delta: float) -> void:
	# next level starting
	if playing and all_coins_collected():
		level += 1
		powerup_spawn_timer.wait_time = randf_range(1.0, 3.0)
		powerup_spawn_timer.start()
		spawn_coins()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("user_start"):
		new_game()
	if event.is_action_pressed("user_quit"):
		get_tree().quit()


func spawn_coins() -> void:
	for i in level + 3:
		var c = coin_scene.instantiate()
		var half_radius = c.get_node("CollisionShape2D").shape.radius / 2
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(
			randi_range(half_radius, screensize.x - half_radius),
			randi_range(half_radius, screensize.y - half_radius)
		)


func spawn_powerup() -> void:
	var p = powerup_scene.instantiate()
	var half_radius = p.get_node("CollisionShape2D").shape.radius / 2
	add_child(p)
	p.screensize = screensize
	p.position = Vector2(
		randi_range(half_radius, screensize.x - half_radius),
		randi_range(half_radius, screensize.y - half_radius)
	)


func new_game():
	score = 0
	level = 1
	time_left = 3.0
	playing = true

	$Sound/Level.play()
	game_tick.start()
	start_button.hide()
	message_label.hide()

	spawn_coins()
	player.set_process(true)


func game_over():
	$Sound/End.play()
	emit_signal("player_die")
	game_tick.stop()
	playing = false
	time_left = 30.0


func on_player_contact_with(object: Area2D) -> void:
	if object.is_in_group("coins"):
		$Sound/Coin.play()
		score += 1
		hud.update_score(score)

	if object.has_method("in_contact"):
		object.in_contact()


func _on_game_tick_timeout() -> void:
	time_left -= 0.1
	if time_left <= 0.0:
		time_left = 0
		game_over()
	hud.update_time(time_left)


func all_coins_collected() -> bool:
	return get_tree().get_nodes_in_group("coins").is_empty()


func no_any_powerups() -> bool:
	return get_tree().get_nodes_in_group("powerups").is_empty()


func _on_powerup_spawn_timer_timeout() -> void:
	spawn_powerup()
