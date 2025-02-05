class_name Player
extends Area2D

@export var speed = 400

var screensize = Vector2.ZERO
var direction = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	screensize = get_viewport_rect().size


func _process(delta: float) -> void:
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	move(delta)

	animated_sprite.flip_h = direction.x < 0

	if direction.length() == 0:
		animated_sprite.animation = "idle"
	else:
		animated_sprite.animation = "run"

	animated_sprite.play()


func move(delta: float) -> void:
	var shape_size = collision_shape.shape.get_rect().size

	position += speed * direction * delta

	position.x = clamp(position.x, shape_size.x / 2, screensize.x - shape_size.x / 2)
	position.y = clamp(position.y, shape_size.y / 2, screensize.y - shape_size.y / 2)
