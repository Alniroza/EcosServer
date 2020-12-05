extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var name_player
var id_player
var lvl_player
var expercience_player


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_id_player(id):
	id_player=id
func set_name_player(player_name):
	name_player = player_name
func set_lvl_player(player_lvl):
	lvl_player=player_lvl
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
