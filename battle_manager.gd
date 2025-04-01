extends Node2D


var main_menu_scene = load("res://main_scenes/main_menu_scene.tscn")
var global_variables := load("res://resources/global_variables/global_variables.tres")
var base_goon_scene = preload("res://goons/goon_scenes/base_goon.tscn")
var lose_screen = preload("res://ui/lose_message.tscn")
var win_screen = preload("res://ui/win_message.tscn")
var paused := false

@onready var player = $Player
@onready var pause_tint = $ColorRect
@onready var exit_button = $ExitToMenu


#var rng = RandomNumberGenerator.new()

func _ready() -> void:
	exit_button.disabled == true
	exit_button.modulate.a = 0
	for n in range(10):
		# await get_tree().create_timer(0.5).timeout
		summon_goon()
	global_variables.current_game_state = global_variables.Game_state.FIGHTING

func _process(delta: float) -> void:
	if global_variables.player_hp == 0:
		global_variables.current_game_state = global_variables.Game_state.LOSE
	if global_variables.master_right_side.is_empty() and global_variables.master_left_side.is_empty():
		var summoned_win_screen = win_screen.instantiate()
		summoned_win_screen.position = Vector2(global_variables.player_pos_x - 395, 20)
		add_child(summoned_win_screen)
		global_variables.current_game_state = global_variables.Game_state.WIN
	if global_variables.current_game_state == global_variables.Game_state.LOSE:
		var summoned_lose_screen =  lose_screen.instantiate()
		summoned_lose_screen.position = Vector2(global_variables.player_pos_x - 395, 20)
		add_child(summoned_lose_screen)

func roll_100():
	return(randf())
	
func summon_goon():
	var dice_roll = roll_100()
	if global_variables.master_right_side.size() + 2 < global_variables.master_left_side.size():
		dice_roll = 1
	if global_variables.master_left_side.size() + 2 < global_variables.master_right_side.size():
		dice_roll = 0
	var summoned_goon = base_goon_scene.instantiate()
	summoned_goon.position.y = 750
	if dice_roll > 0.5:
		global_variables.master_right_side.append(summoned_goon)
		summoned_goon.position.x = player.position.x + 1400 + 200 * global_variables.master_right_side.size() + 80 * randf()
		summoned_goon.goon_approach = summoned_goon.Incoming.RIGHT
	else:
		global_variables.master_left_side.append(summoned_goon)
		summoned_goon.position.x = player.position.x - 1400 - 200 * global_variables.master_left_side.size() + 80 * randf()
		summoned_goon.goon_approach = summoned_goon.Incoming.LEFT
	summoned_goon.knocked_back.connect(knock_back_goons)
	add_child(summoned_goon)
	
func knock_back_goons():
	for n in global_variables.master_right_side:
		n.knock_back()
	for n in global_variables.master_left_side:
		n.knock_back()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if paused == false:
			global_variables.current_game_state = global_variables.Game_state.PAUSED
			pause_tint.modulate.a = 0.5
			exit_button.modulate.a = 1
			exit_button.position = Vector2(global_variables.player_node.position.x, exit_button.position.y)
			exit_button.disabled = false
			get_tree().paused = true
			paused = true
			return
		if paused == true:
			if (global_variables.master_right_side.is_empty() and global_variables.master_left_side.is_empty()) or global_variables.player_hp == 0:
				return
			else:
				exit_button.disabled == true
				exit_button.modulate.a = 0
				global_variables.current_game_state = global_variables.Game_state.FIGHTING
				pause_tint.modulate.a = 0
				get_tree().paused = false
				paused = false
				return
			
		


func _on_exit_to_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(main_menu_scene)
	
