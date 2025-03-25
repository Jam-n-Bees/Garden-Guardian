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

func _process(delta: float) -> void:
	if goon_approach == Incoming.RIGHT:
		self.position.x -= delta*base_speed*slow_down
	if goon_approach == Incoming.LEFT:
		self.position.x += delta*base_speed*slow_down

func pause():
	slow_down = 0
	await get_tree().create_timer(1).timeout
	var accelerate = create_tween()
	accelerate.tween_property(self,"slow_down",1,1.5)
	
func _ready() -> void:
	pause()
