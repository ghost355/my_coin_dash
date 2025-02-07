class_name HUD
extends CanvasLayer

@onready var score_label = $Counters/ScoreLabel
@onready var time_label = $Counters/TimeLeftLabel
@onready var message_label = $MessageLabel
@onready var start_button = $MarginContainer2/StartButton
@onready var main = owner


func _ready() -> void:
	main.start_game.connect(on_main_start_game)
	main.game_over.connect(on_main_game_over)


func update_score(score: int) -> void:
	score_label.text = "%d" % score


func update_time(time: float) -> void:
	time_label.text = "%.1f" % time


func show_message(message: String, showtime: float) -> void:
	message_label.text = message
	message_label.show()
	await get_tree().create_timer(showtime).timeout
	message_label.hide()


func on_main_start_game() -> void:
	message_label.hide()
	start_button.hide()


func on_main_game_over() -> void:
	update_time(0.0)
	await show_message("Конец игры", 2.0)
	message_label.text = "Собирай монетки!"
	message_label.show()
	start_button.show()
