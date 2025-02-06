class_name HUD
extends CanvasLayer

@onready var score_label = $Counters/ScoreLabel
@onready var time_label = $Counters/TimeLeftLabel
@onready var message_label = $MessageLabel


func update_score(score: int) -> void:
	score_label.text = "%d" % score


func update_time(time: float) -> void:
	time_label.text = "%.1f" % time


func show_message(message: String, showtime: float) -> void:
	message_label.text = message
	message_label.show()
	print("Timeout start")
	await get_tree().create_timer(showtime).timeout
	message_label.hide()
