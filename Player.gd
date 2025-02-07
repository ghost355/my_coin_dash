class_name Player

extends Area2D

signal pickup

@export var speed = 400

var screensize = Vector2.ZERO
var direction = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var main = owner


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	main.start_game.connect(on_main_start_game)
	main.game_over.connect(on_main_game_over)

	screensize = get_viewport_rect().size
	position = screensize / 2
	z_index = 1


func _process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	move(delta)


func move(delta: float) -> void:
	var shape_size = collision_shape.shape.get_rect().size

	position += speed * direction * delta

	position.x = clamp(position.x, shape_size.x / 2, screensize.x - shape_size.x / 2)
	position.y = clamp(position.y, shape_size.y / 2, screensize.y - shape_size.y / 2)

	if direction.x < 0:
		animated_sprite.flip_h = true
	elif direction.x > 0:
		animated_sprite.flip_h = false

	if direction.length() == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		$CoinSound.play()
		emit_signal("pickup", area)
	if area.is_in_group("powerups"):
		$PowerupSound.play()
		emit_signal("pickup", area)
	if area.is_in_group("obstacles"):
		$ObstacleSound.play()
		emit_signal("pickup", area)
		die()


func on_main_game_over() -> void:
	die()


func on_main_start_game() -> void:
	start_game()


func die() -> void:
	animated_sprite.play("hurt")
	set_process(false)
	await Utils.async_scale_and_dissolve(self, 2.0)
	reset_initial_state()


func start_game() -> void:
	set_process(true)


func reset_initial_state() -> void:
	modulate.a = 1
	scale = Vector2.ONE
	position = screensize / 2
