extends Node

@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene

var level = 1
var speed = 350
var screensize = Vector2.ZERO
var time_left = 30
var score = 0

@onready var player = $Player
@onready var hud = $HUD


func _ready() -> void:
	player.contact_with.connect(on_player_contact_with)
	screensize = get_viewport().size

	spawn_coins()


func _process(delta: float) -> void:
	pass


func spawn_coins() -> void:
	for i in level * 5:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))


func on_player_contact_with(object: Area2D) -> void:
	if object.is_in_group("coins"):
		score += 1
		hud.update_score(score)

	if object.has_method("in_contact"):
		object.in_contact()
