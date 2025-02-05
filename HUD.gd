class_name HUD
extends CanvasLayer

@onready var score_label = $Counters/ScoreLabel
@onready var time_label = $Counters/TimeLabel
@onready var message_label = $MessageLabel


func update_score(score: int) -> void:
	score_label.text = "%d" % score


func update_time(time: int) -> void:
	time_label.text = "%d" % time


func print_message(message: String, showtime: float) -> void:
	message_label.text = message
	await get_tree().create_timer(showtime).timeout
