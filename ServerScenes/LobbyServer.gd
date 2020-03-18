extends Node2D

onready var GameLobby = preload("res://ServerScenes/GameLobbyServer.tscn")


var connected_players = []

#Encargado de todo lo relacionado a la interaccion de los jugadores pre-partida

remote func matchmaking():
	#TODO Esta funcion deberia ser llamada para crear game lobbys
	pass


#Les creamos partidas de juego a los jugadores. 
remote func new_gamelobby_server(call_id):
	#Aca se debe creear un nuevo GameLobby por cada matchmaking concluido.
	#TODO cambiar nombres
	var gamelobby_name = "GameLobby123"
	print("Creando nuevo gamelobbyServer - ", gamelobby_name)
	var asked_gamelobby = get_parent().get_node_or_null(gamelobby_name)
	if asked_gamelobby:
		print("Ya existe este Lobby")
		pass
	else:
		var gamelobby_instance = GameLobby.instance()
		gamelobby_instance.set_name(gamelobby_name)
		gamelobby_instance.set_network_master(1)
		get_parent().add_child(gamelobby_instance)
		
	rpc_id(call_id ,"new_gamelobby", 1, gamelobby_name)
	pass
	