extends Node2D

onready var Gamelobby = preload("res://ServerScenes/GameLobbyServer.tscn")
onready var PlayerServer = preload("res://Characters/PlayerServer.tscn")

#¿Que mas deberia tener los players?
onready var PlayersDatabase = [
	{"username" : "goduser", "password" : "goduser"}
	]

#Lobby
#|->GameLobbies (just to group gamelobbies)
#| |->GameLobby#1
#| | |->World
#| | |->Character1	Esta parte podria ser diferente
#| | |->Character2
#| | |...
#| |->GameLobby#2
#| |...
#|->Player1
#|->Player2
#|...

#Encargado de todo lo relacionado a la interaccion de los jugadores pre-partida
#Como conectar a partidas, comunicarse con amigos, buscar partida, etc.

#Autenticar una cuenta:
remote func authenticate(username, password):
	var player_id = get_tree().get_rpc_sender_id()
	#Player se obtiene de una BD
	#y se le copia al servidor cuando se conecta.
	for Player in PlayersDatabase:
		if [Player.username, Player.password] == [username, password]:
			#Validar conexion, traer jugador al lobby.
			return rpc("new_player", Player, player_id)
			
	return 0
	
master func new_Player(Player, id):
	#Agregamos al Lobby un nuevo Player, si no existe.
	if(find_node(str(id)) == null):
		#Configuramos player
		var player_instance = PlayerServer.instance()
		player_instance.set_name(str(id))
		player_instance.set_network_master(id)
		return add_child(player_instance)
	else:
		#si existe, jugador ya conectado? que se hace aca?
		pass
		
	return

#Player es la informacion del que busca partida, y el gamemode que elige.
remote func matchmaking(id, gamemode):
	#TODO Esta funcion deberia ser llamada para juntar a los jugadores
	
	var Gamelobbies = $Gamelobbies.get_children()
	
	#TODO separar por gamemodes
	for Game in Gamelobbies:
		if Game.max_players > Game.current_players:
			#Si podemos entrar a una partida, entramos.
			return 1
			
	var new_Gamelobby = new_Gamelobby(gamemode)
	var Player = find_node(str(id))
	
	return 1

#Les creamos partidas de juego a los jugadores. 
remote func new_Gamelobby(gamemode):
	#Aca se debe creear un nuevo GameLobby por cada matchmaking concluido.
	#TODO Crear nombres de alguna forma
	var gamelobby_name = "GameLobby123"
	
	var gamelobby_config = {
		"name": gamelobby_name,
		"gamemode": "versus",
		"connected_players": [],
		"elo": 0
		}
	
	print("Creando nuevo gamelobbyServer - ", gamelobby_name)
	
	var Gamelobby_instance = Gamelobby.instance()
	Gamelobby_instance.set_name(gamelobby_name)
	Gamelobby_instance.set_network_master(1)
	Gamelobby_instance.config = gamelobby_config
	$Gamelobbies.add_child(Gamelobby_instance)
	
	return gamelobby_name
	
func join_gamelobby(Player, GameLobby):
	GameLobby.add_child(Player)
	pass