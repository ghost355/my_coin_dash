extends Node

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var speed = 350

var screensize = Vector2.ZERO
var level = 1
var time_left = 30.0
var playing = false
var coin_amount = 3
var score = 0

@onready var player = $Player
@onready var hud = $HUD
@onready var game_tick = $GameTick
@onready var start_button = $HUD/MarginContainer2/StartButton
@onready var message_label = $HUD/MessageLabel


func _ready() -> void:
	player.contact_with.connect(on_player_contact_with)
	game_tick.timeout.connect(_on_game_tick_timeout)

	screensize = get_viewport().size


func _process(delta: float) -> void:
	# next level starting
	if playing and coins_collected():
		level += 1
		coin_amount += 2
		spawn_coins()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("user_start"):
		new_game()


func spawn_coins() -> void:
	for i in coin_amount:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))


func new_game():
	score = 0
	level = 1
	time_left = 30
	playing = true

	game_tick.start()
	start_button.hide()
	message_label.hide()

	spawn_coins()


func game_over():
	game_tick.stop()
	player.animated_sprite.play("hurt")


func on_player_contact_with(object: Area2D) -> void:
	if object.is_in_group("coins"):
		score += 1
		hud.update_score(score)

	if object.has_method("in_contact"):
		object.in_contact()


func _on_game_tick_timeout() -> void:
	time_left -= 0.1
	hud.update_time(time_left)

	if time_left == 0:
		game_over()


func coins_collected() -> bool:
	return get_tree().get_nodes_in_group("coins").is_empty()
