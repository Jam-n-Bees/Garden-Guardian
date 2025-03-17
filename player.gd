extends Node2D

var attack_cooldown_stat := 3
var attack_cooldown_time : float
@onready var attack_on_cooldown := false


func _process(delta: float) -> void:
	if attack_on_cooldown == true:
		if attack_cooldown_time <= 0:
			attack_on_cooldown = false
		else:
			attack_cooldown_time -= (1*delta)

			
			
			
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
