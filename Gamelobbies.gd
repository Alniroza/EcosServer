extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func remove_peer(the_id,id_to_remove,lobby_name):
	rpc_id(the_id,"kick_someone",id_to_remove,lobby_name)
	
remote func delete_gamelobby(gamelobby):
	if self.has_node(gamelobby):
		get_node(gamelobby).queue_free()
		print("Borré el game lobby : ", gamelobby)
		
remote func update_leaderboard(name_gamemode, places, lobby_name):
	print(places)
	if self.has_node(lobby_name) :
		if get_node(lobby_name).score_received != true : 
			if name_gamemode == "survival":
				var new_places = places
				new_places.invert()
				get_parent().update_leaderboard(name_gamemode, new_places)
			if name_gamemode == "deathmatch":
				get_parent().update_leaderboard(name_gamemode, places)
			if name_gamemode == "teamdeathmatch":
				get_parent().update_leaderboard(name_gamemode, places)
			get_node(lobby_name).score_received = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
