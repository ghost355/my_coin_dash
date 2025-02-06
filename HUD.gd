class_name HUD
extends CanvasLayer

var time_left: float

@onready var score_label = $Counters/ScoreLabel
@onready var time_label = $Counters/TimeLeftLabel
@onready var message_label = $MessageLabel
@onready var start_button = $MarginContainer2/StartButton


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


func _on_main_player_die() -> void:
	await show_message("Конец игры", 2.0)
	message_label.text = "Собери монетки!"
	message_label.show()
	start_button.show()
