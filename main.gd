extends Node

signal game_over
signal start_game

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var speed = 350
@export var powerup_lifetime = 3
@export var time_constant = 30.0

var screensize = Vector2.ZERO
var level = 1
var playing = false
var score = 0
var time_left = time_constant

@onready var player = $Player
@onready var hud = $HUD
@onready var game_tick = $GameTick
@onready var start_button = $HUD/MarginContainer2/StartButton
@onready var message_label = $HUD/MessageLabel
@onready var powerup_spawn_timer = $PowerupSpawnTimer


func _ready() -> void:
	self.game_over.connect(on_game_over)
	self.start_game.connect(on_start_game)
	game_tick.timeout.connect(_on_game_tick_timeout)
	player.pickup.connect(on_player_pickup)

	screensize = get_viewport().size
	player.screensize = screensize


func _process(delta: float) -> void:
	# next level starting
	if playing and all_coins_collected():
		level += 1
		powerup_spawn_timer.wait_time = randf_range(1.0, 3.0)
		powerup_spawn_timer.start()
		spawn_coins()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("user_start"):
		emit_signal("start_game")
	if event.is_action_pressed("user_quit"):
		get_tree().quit()


func spawn_coins() -> void:
	for i in level + 3:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.spawn()


func spawn_powerup() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.screensize = screensize
	p.spawn()


func on_start_game():
	score = 0
	level = 1
	time_left = time_constant
	playing = true

	$Sound/Level.play()
	game_tick.start()

	spawn_coins()


func on_game_over():
	$Sound/End.play()
	game_tick.stop()
	playing = false


func _on_game_tick_timeout() -> void:
	time_left -= 0.1
	if time_left <= 0.0:
		time_left = 0
		emit_signal("game_over")
	hud.update_time(time_left)


func all_coins_collected() -> bool:
	return get_tree().get_nodes_in_group("coins").is_empty()


func no_any_powerups() -> bool:
	return get_tree().get_nodes_in_group("powerups").is_empty()


func _on_powerup_spawn_timer_timeout() -> void:
	spawn_powerup()


func on_player_pickup(target: Area2D) -> void:
	if target.is_in_group("coins"):
		score += 1
		hud.update_score(score)
		target.collected()
	if target.is_in_group("powerups"):
		time_left += 5
		target.collected()
	if target.is_in_group("obstacles"):
		emit_signal("game_over")
