class_name Goon

extends Node2D

signal attack
signal defeated

enum Incoming { RIGHT, LEFT }

var goon_approach = Incoming.RIGHT

var base_speed := 250
var base_threat := 1

var slow_down := 1

func _process(delta: float) -> void:
	if goon_approach == Incoming.RIGHT:
		self.position.x -= delta*base_speed*slow_down
	if goon_approach == Incoming.LEFT:
		self.position.x += delta*base_speed*slow_down
