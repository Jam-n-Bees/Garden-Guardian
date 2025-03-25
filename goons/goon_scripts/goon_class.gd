class_name Goon

extends Node2D

signal attack
signal defeated

enum Incoming { RIGHT, LEFT }

var goon_approach = Incoming.RIGHT

var base_speed := 300
var base_threat := 1

var slow_down : float = 1
var speed_up_delay : float = 1

var knocked_out := false

var global_variables := load("res://resources/global_variables/global_variables.tres")

func _process(delta: float) -> void:
	if knocked_out == false:
		if goon_approach == Incoming.RIGHT:
			self.position.x -= delta*base_speed*slow_down
		if goon_approach == Incoming.LEFT:
			self.position.x += delta*base_speed*slow_down
	else:
		pass

func _ready() -> void:
	pass

func pause():
	slow_down = 0
	await get_tree().create_timer(1).timeout
	var accelerate = create_tween()
	accelerate.tween_property(self,"slow_down",1,1.5)

func knockout():
	knocked_out = true
	var rotate = create_tween()
	var nyoom = create_tween()
	if goon_approach == Incoming.RIGHT:
		var target_x = global_variables.player_pos_x + 1000
		var target := Vector2(target_x, -100)
		rotate.tween_property(self,"rotation_degrees",3000,3)
		nyoom.tween_property(self,"position", target, 1)
	if goon_approach == Incoming.LEFT:
		var target_x = global_variables.player_pos_x - 1000
		var target := Vector2(target_x, -100)
		rotate.tween_property(self,"rotation_degrees",-3000,3)
		nyoom.tween_property(self,"position", target, 1)
		
	
	
