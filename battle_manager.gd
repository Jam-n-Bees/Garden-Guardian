extends Node2D


var global_variables := load("res://resources/global_variables/global_variables.tres")
var base_goon_scene = preload("res://goons/goon_scenes/base_goon.tscn")

@onready var player = $Player

#var rng = RandomNumberGenerator.new()

func _ready() -> void:
	for n in range(10):
		await get_tree().create_timer(0.5).timeout
		summon_goon()
		pass
	
func roll_100():
	return(randf())
	
func summon_goon():
	var dice_roll = roll_100()
	var summoned_goon = base_goon_scene.instantiate()
	summoned_goon.position.y = 750
	if dice_roll > 0.5:
		global_variables.right_side.append(summoned_goon)
		summoned_goon.position.x = player.position.x + 1400
		summoned_goon.goon_approach = summoned_goon.Incoming.RIGHT
	else:
		global_variables.left_side.append(summoned_goon)
		summoned_goon.position.x = player.position.x - 1400
		summoned_goon.goon_approach = summoned_goon.Incoming.LEFT
	summoned_goon.knocked_back.connect(knock_back_goons)
	add_child(summoned_goon)
	
func knock_back_goons():
	for n in global_variables.right_side:
		n.knock_back()
	for n in global_variables.left_side:
		n.knock_back()
	
		
