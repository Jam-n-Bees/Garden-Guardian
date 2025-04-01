extends Node2D

var attack_cooldown_stat := 1.5
var attack_cooldown_time : float
@onready var attack_on_cooldown := false
var global_variables := load("res://resources/global_variables/global_variables.tres")
var player_hp_bar := preload("res://ui/health_bar.tscn")

func _ready() -> void:
	var hp_bar = player_hp_bar.instantiate()
	global_variables.player_hp_bar = hp_bar
	add_child(hp_bar)
	global_variables.player_node = self

func _process(delta: float) -> void:
	if attack_on_cooldown == true:
		if attack_cooldown_time <= 0:
			attack_on_cooldown = false
		else:
			attack_cooldown_time -= (1*delta)
	global_variables.player_pos_x = self.position.x
	global_variables.player_pos_y = self.position.y

func _input(event: InputEvent) -> void:
	if attack_on_cooldown == false and global_variables.current_game_state == global_variables.Game_state.FIGHTING:
		if event.is_action_pressed("punch_right"):
			if not global_variables.right_side.is_empty():
				var closest_target
				var current_closest_range := 100000
				closest_target = global_variables.right_side[0]
				for n in global_variables.right_side:
					if is_instance_valid(n):
						if n.global_position.x - self.global_position.x < current_closest_range:
							current_closest_range = n.global_position.x - self.global_position.x
							closest_target = n
				if is_instance_valid(closest_target):
					closest_target.interupted = true
					var dash = create_tween()
					dash.tween_property(self,"position", Vector2(closest_target.position.x - 80, self.position.y), 0.1)
					await dash.finished
					closest_target.knockout()
			else:
				self.position.x += 200
				attack_on_cooldown = true
				attack_cooldown_time = attack_cooldown_stat
			
			
		if event.is_action_pressed("punch_left"):
			if not global_variables.left_side.is_empty():
				var closest_target
				var current_closest_range := 100000
				closest_target = global_variables.left_side[0]
				for n in global_variables.left_side:
					if is_instance_valid(n):
						if self.global_position.x - n.global_position.x < current_closest_range:
							current_closest_range = self.global_position.x - n.global_position.x
							closest_target = n
				if is_instance_valid(closest_target):
					closest_target.interupted = true
					var dash = create_tween()
					dash.tween_property(self,"position", Vector2(closest_target.position.x + 80, self.position.y), 0.1)
					await dash.finished
				closest_target.knockout()
			else:
				self.position.x -= 200
				attack_on_cooldown = true
				attack_cooldown_time = attack_cooldown_stat
				
				
		

func _on_rs_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.ad_right_side.emit()

func _on_ls_detect_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.ad_left_side.emit()

func _on_attackable_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.in_range.emit()


func _on_rs_detect_area_exited(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.remove_right_side.emit()


func _on_ls_detect_area_exited(area: Area2D) -> void:
	if area.is_in_group("EnemyBox"):
		area.remove_left_side.emit()
