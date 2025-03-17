extends Node2D

var attack_cooldown_stat := 3
var attack_cooldown_time : float
@onready var attack_on_cooldown := false
var punch_zone_res := load("res://punch_zone.tres")


func _process(delta: float) -> void:
	if attack_on_cooldown == true:
		if attack_cooldown_time <= 0:
			attack_on_cooldown = false
		else:
			attack_cooldown_time -= (1*delta)

			
			
			
func _input(event: InputEvent) -> void:
	if attack_on_cooldown == false:
		if event.is_action_pressed("punch_right"):
			if not punch_zone_res.punch_zone_right.is_empty():
				self.position.x = punch_zone_res.punch_zone_right[0].get_parent().position.x - 100
				await get_tree().create_timer(0.5).timeout
				punch_zone_res.punch_zone_right[0].get_parent().queue_free()
				punch_zone_res.punch_zone_right.remove_at(0)
				print(str(punch_zone_res.punch_zone_right))
				
			else:
				self.position.x += 200
				attack_on_cooldown = true
				attack_cooldown_time = attack_cooldown_stat
			
			
			
		if event.is_action_pressed("punch_left"):
			self.position.x -= 200
			attack_on_cooldown = true
			attack_cooldown_time = attack_cooldown_stat


func rs_punch_zone_detect(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		print("Enemy detected, 3 o'clock!!!")
		punch_zone_res.punch_zone_right.append(area)
		print(str(punch_zone_res.punch_zone_right))


func ls_punch_zone_detect(area: Area2D) -> void:
	if area.is_in_group("enemy"):
		print("Enemy detected, 9 o'clock!!!")
		punch_zone_res.punch_zone_left.append(area)
		print(str(punch_zone_res.punch_zone_left))
