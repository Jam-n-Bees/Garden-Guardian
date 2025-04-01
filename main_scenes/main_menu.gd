extends Node2D

var stage_1 = load("res://main_scenes/MainScene.tscn")

func _on_exit_game_pressed() -> void:
	get_tree().quit()


func _on_stage_1_pressed() -> void:
	get_tree().change_scene_to_packed(stage_1)
