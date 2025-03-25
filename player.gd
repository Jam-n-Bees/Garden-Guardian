extends Node2D

var attack_cooldown_stat := 3
var attack_cooldown_time : float
@onready var attack_on_cooldown := false
var global_variables := load("res://resources/global_variables/global_variables.tres")

func _process(delta: float) -> void:
	if attack_on_cooldown == true:
		if attack_cooldown_time <= 0:
			attack_on_cooldown = false
		else:
			attack_cooldown_time -= (1*delta)
	global_variables.player_pos_x = self.position.x
	global_variables.player_pos_y = self.position.y
	
func _input(event: InputEvent) -> void:
	if attack_on_cooldown == false:
		if event.is_action_pressed("punch_right"):
			self.position.x += 200
			attack_on_cooldown = true
			attack_cooldown_time = attack_cooldown_stat
		if event.is_action_pressed("punch_left"):
			self.position.x -= 200
			attack_on_cooldown = true
			attack_cooldown_time = attack_cooldown_stat




func _on_rs_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.ad_right_side.emit()




func _on_ls_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.ad_left_side.emit()
