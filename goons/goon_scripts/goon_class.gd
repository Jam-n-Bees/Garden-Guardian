class_name Goon

extends Node2D

signal attack
signal defeated
signal knocked_back


enum Incoming { RIGHT, LEFT }

var goon_approach = Incoming.RIGHT

var base_speed := 300
var base_threat := 1

var slow_down : float = 1
var speed_up_delay : float = 1

var knocked_out := false
var interupted := false
var attacking := false

var global_variables := load("res://resources/global_variables/global_variables.tres")

# URGENT NOTE should be replaced by instantiating the area as a child
# this is v problematic
@onready var goon_hit_box := $GoonArea

func _ready() -> void:
	goon_hit_box.ad_right_side.connect(add_right_array)
	goon_hit_box.ad_left_side.connect(add_left_array)
	goon_hit_box.in_range.connect(attack_player)
	goon_hit_box.remove_right_side.connect(remove_right_array)
	goon_hit_box.remove_left_side.connect(remove_left_array)
	pass

# NOTE
# So long as the goon is not KO'd, it will move towards the player
func _process(delta: float) -> void:
	if knocked_out == false:
		if interupted == true or attacking == true:
			return
		if goon_approach == Incoming.RIGHT:
			self.position.x -= delta*base_speed*slow_down
		if goon_approach == Incoming.LEFT:
			self.position.x += delta*base_speed*slow_down

# NOTE 
# This function is used whenever something might hold the goons briefly
# This may be because the player was hit, or using an item of ability
# The function sets the "slow_down" to 0 (a multiplier in the move speeed)
# then waits for seconds indictated by the "speed_up_delay"
# and then tweens the property, to go back up to 1, over the timespan of 1.5 seconds
# the timespan may be changed, and may even be influenced by level difficulty later
func pause():
	slow_down = 0
	await get_tree().create_timer(speed_up_delay).timeout
	var accelerate = create_tween()
	accelerate.tween_property(self,"slow_down",1,2)

# NOTE
# The below function should be called when the goon is defeated
# Sets knockout to true, then creates the neccesary tweens
# based on whether it is on the left or right side,
# it'll go zooming off screen, position relatively proportional to the player
# and also spin off like team rocket in the apropriate direction
# As a little test, when the tween is over, it prints to console, "Dead!"
# then deletes itself
func knockout():
	knocked_out = true
	var rotate = create_tween()
	var nyoom = create_tween()
	if goon_approach == Incoming.RIGHT:
		global_variables.right_side.erase(self)
		global_variables.master_right_side.erase(self)
		var target_x = global_variables.player_pos_x + 1000
		var target := Vector2(target_x, -100)
		rotate.tween_property(self,"rotation_degrees",3000,3)
		nyoom.tween_property(self,"position", target, 1)
	if goon_approach == Incoming.LEFT:
		global_variables.left_side.erase(self)
		global_variables.master_left_side.erase(self)
		var target_x = global_variables.player_pos_x - 1000
		var target := Vector2(target_x, -100)
		rotate.tween_property(self,"rotation_degrees",-3000,3)
		nyoom.tween_property(self,"position", target, 1)
	await nyoom.finished
	print("Dead!")
	self.queue_free()

func add_right_array():
	if global_variables.right_side.find(self) > -1:
		return
	print("Right side!")
	global_variables.right_side.append(self)
	pass

func add_left_array():
	if global_variables.left_side.find(self) > -1:
		return
	global_variables.left_side.push_front(self)
	print("Left side!")
	pass

func remove_right_array():
	global_variables.right_side.erase(self)

func remove_left_array():
	global_variables.left_side.erase(self)

func attack_player():
	attacking = true
	await get_tree().create_timer(0.2).timeout
	if interupted == false:
		global_variables.player_hp -= 1
		global_variables.player_hp_bar.value = global_variables.player_hp
	emit_signal("knocked_back")
	attacking = false

func knock_back():
	interupted = true
	await get_tree().create_timer(0.5).timeout
	var nyoomers = create_tween()
	var target
	if self.goon_approach == Incoming.RIGHT:
		target = Vector2(self.position.x + 500, self.position.y)
	if self.goon_approach == Incoming.LEFT:
		target = Vector2(self.position.x - 500, self.position.y)
	nyoomers.tween_property(self,"position", target, 0.8)
	await nyoomers.finished
	interupted = false
	pause()
	
	
	
	
