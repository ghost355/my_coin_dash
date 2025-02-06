class_name Powerup
extends Area2D

var screensize = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $AnimationTimer
@onready var collision_shape = $CollisionShape2D


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	random_timer(0.5, 1.5)


func _on_timer_timeout() -> void:
	animated_sprite.play()


func random_timer(from: float, to: float) -> void:
	var time = randf_range(from, to)
	timer.wait_time = time
	timer.start()


func in_contact() -> void:
	collision_shape.set_deferred("disabled", true)
	await Utils.async_scale_and_dissolve(self)
	queue_free()
