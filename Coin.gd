class_name Coin
extends Area2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var timer = $AnimationTimer


func _ready() -> void:
	timer.timeout.connect(_on_timer_timeout)
	random_timer(0.5, 4.5)


func _on_timer_timeout() -> void:
	animated_sprite.play()
	random_timer(0.5, 4.5)


func random_timer(from: float, to: float) -> void:
	var time = randf_range(from, to)
	timer.wait_time = time
	timer.start()


func pickuped() -> void:
	var tw = create_tween().set_parallel().set_trans(Tween.TRANS_QUAD)
	tw.tween_property(self, "scale", scale * 3, 0.2)
	tw.tween_property(self, "modulate:a", 0, 0.3)
	await tw.finished
	queue_free()
