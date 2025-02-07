class_name Powerup
extends Area2D

var screensize = Vector2.ZERO

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $AnimationTimer
@onready var collision_shape = $CollisionShape2D
@onready var lifetime_timer = $LifetimeTimer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	lifetime_timer.timeout.connect(_on_lifetime_timer_timeout)
	random_timer(0.5, 1.5)


func _on_timer_timeout() -> void:
	animated_sprite.play()


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func random_timer(from: float, to: float) -> void:
	var time = randf_range(from, to)
	timer.wait_time = time
	timer.start()


func in_contact() -> void:
	collision_shape.set_deferred("disabled", true)
	await Utils.async_scale_and_dissolve(self, 2.0)
	queue_free()


func spawn() -> void:
	var offset = collision_shape.shape.radius / 2
	position = Vector2(
		randf_range(offset, screensize.x + offset), randf_range(0, screensize.y + offset)
	)

func collected() -> void:
	collision_shape.set_deferred("disabled", true)
	queue_free()
