extends Resource

var main_menu_scene = preload("res://goons/goon_scenes/base_goon.tscn")

var player_pos_x
var player_pos_y

var right_side := []
var left_side := []

var master_right_side := []
var master_left_side := []

var player_hp_bar
var player_hp := 2

var player_node

var current_game_state 

enum Game_state { FIGHTING , LOSE, WIN , PAUSED }
