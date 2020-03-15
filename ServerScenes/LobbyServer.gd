extends Node2D

onready var GameLobby = preload("res://ServerScenes/GameLobbyServer.tscn")


var connected_players = []

#Encargado de todo lo relacionado a la interaccion de los jugadores pre-partida

remote func matchmaking():
	#TODO Esta funcion deberia ser llamada para crear game lobbys
	pass


#Les creamos partidas de juego a los jugadores. 
remote func new_gamelobby_server(call_id, gamelobby_name):
	print("Creando nuevo gamelobbyServer - ", gamelobby_name)
	if 0:
	#get_parent().get_node_or_null(gamelobby_name):
		pass
	else:
		var gamelobby_instance = GameLobby.instance()
		gamelobby_instance.set_name(gamelobby_name)
		gamelobby_instance.set_network_master(1)
		get_parent().add_child(gamelobby_instance)
		
		rpc("new_gamelobby", 1, gamelobby_name)
	pass
	