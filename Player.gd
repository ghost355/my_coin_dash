class_name Player

extends Area2D

signal pickup

@export var speed = 400

var screensize = Vector2.ZERO
var direction = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	screensize = get_viewport_rect().size
	position = screensize / 2


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
		# animated_sprite.animation = "idle"
		animated_sprite.play("idle")
	else:
		animated_sprite.play("run")

	# animated_sprite.play()


func _on_enter_area(area: Area2D) -> void:
	var group = area.get_groups()[0]
	emit_signal("pickup", group)
