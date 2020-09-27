extends Node2D

onready var Gamelobby = preload("res://ServerScenes/GameLobbyServer.tscn")
onready var PlayerServer = preload("res://Characters/PlayerServer.tscn")

#¿Que mas deberia tener los players?
onready var PlayersDatabase = [
	{"username" : "goduser", "password" : "goduser"},
	{"username" : "god", "password" : "god"},
	{"username" : "a", "password" : "a"},
	{"username" : "b", "password" : "b"}
	]
	
var new_registered_player={}
var Players_connected={}

var isparty
var countlobby = 1

#Variable que guardará a los players esperando por encontrar partida
var firsteam
var secondteam
var WaitingMode1 = []
var PlayersWaitingmode1 = {1:[]}
var countmode1 = 1
var WaitingMode2 = []
var PlayersWaitingmode2 = {1:[]}
var countmode2 = 1
var WaitingMode3 = []
var countmode3 = 1


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

#Registrar usuarios

remote func registry_user(usern,passw,idpeer):
	var exist=false
	for nombres in PlayersDatabase:
		if nombres["username"]==usern or nombres["password"]==passw:
			rpc_id(idpeer,"_denied_registry")
			exist=true
	if exist != true:
		new_registered_player["username"] = usern
		new_registered_player["password"] = passw
		PlayersDatabase.append(new_registered_player)
		new_registered_player={}
		rpc_id(idpeer,"_accept_registry")
		


#Identificar id de los usuarios

remote func search_id_friend(friendname,idpeer):
	print(Players_connected)
	for cont in Players_connected.keys():
		if cont == friendname:
			print("entré aca y entregaré : ", Players_connected[friendname])
			rpc_id(idpeer,"_receive_id_friend",Players_connected[friendname])

#Autenticar una cuenta:
remote func authenticate(username, password):
	var player_id = get_tree().get_rpc_sender_id()
	print ("el id del men que llama es :" + str(get_tree().get_rpc_sender_id()))
	#Player se obtiene de una BD
	#y se le copia al servidor cuando se conecta.
	for Player in PlayersDatabase:
		if [Player.username, Player.password] == [username, password]:
			#Validar conexion, traer jugador al lobby.
			Players_connected[username]=player_id
			return rpc_id(player_id,"new_player", Player, player_id)
			
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
remote func matchmaking(id, gamemode,players,party):
	if party == false:
		if gamemode == "modo1" :
			WaitingMode1=PlayersWaitingmode1[1]
			WaitingMode1.append(id)
			PlayersWaitingmode1[1]=WaitingMode1
		if gamemode == "modo2" :
			WaitingMode2=PlayersWaitingmode2[1]
			WaitingMode2.append(id)
			PlayersWaitingmode2[1]=WaitingMode2
	else:
		if gamemode == "modo1" :
			var joined = false
			for playersmode1 in PlayersWaitingmode1:
				countmode1=playersmode1
				if PlayersWaitingmode1.size()+players.size()>3:
					pass
				else:
					for a in players:
						PlayersWaitingmode1[playersmode1].append(players[a])
			if joined!=true:
				PlayersWaitingmode1[countmode1+1]=players.values()
		if gamemode == "modo2" :
			var joined = false
			for playersmode2 in PlayersWaitingmode2:
				countmode2=playersmode2
				if PlayersWaitingmode2.size()+players.size()>2:
					pass
				else:
					for a in players:
						PlayersWaitingmode2[playersmode2].append(players[a])
			if joined!=true:
				PlayersWaitingmode2[countmode2+1]=players.values()
				
					
		countmode1 = 1
		countmode2 = 1
	if gamemode== "modo1":
		for matchmodel1ready in PlayersWaitingmode1:
			if PlayersWaitingmode1[matchmodel1ready].size() == 2:
				new_Gamelobby(gamemode,PlayersWaitingmode1[matchmodel1ready],false)
				PlayersWaitingmode1.erase(matchmodel1ready)
	if gamemode == "modo2":
		var isready = 0
		var first_key
		var second_key
		var playersmode2
		for teamreadymode2 in PlayersWaitingmode2:
				if PlayersWaitingmode2[teamreadymode2].size() == 2:
					if isready == 0 :
						firsteam = PlayersWaitingmode2[teamreadymode2]
						first_key=teamreadymode2
						isready+=1
					elif isready == 1:
						secondteam = PlayersWaitingmode2[teamreadymode2]
						second_key=teamreadymode2
						isready+=1
		if isready == 2:
			var allplayers=[]
			for a in firsteam:
				allplayers.append(a)
			for b in secondteam:
				allplayers.append(b)
			new_Gamelobby(gamemode,allplayers,true)
			PlayersWaitingmode2.erase(first_key)
			PlayersWaitingmode2.erase(second_key)

#Les creamos partidas de juego a los jugadores. 
remote func new_Gamelobby(gamemode,players,isteam):
	#Aca se debe creear un nuevo GameLobby por cada matchmaking concluido.
	#TODO Crear nombres de alguna forma
	
	var gamelobby_name = "GameLobby"+str(countlobby)
	print(players) 
	var gamelobby_config = {}
	if isteam == false:
		gamelobby_config = {
			"name": gamelobby_name,
			"gamemode": "versus",
			"connected_players": players,
			"elo": 0
			}
	elif isteam == true:
		gamelobby_config = {
			"name": gamelobby_name,
			"gamemode": "versus",
			"first_team" : firsteam,
			"second_team" : secondteam,
			"elo": 0
			}
		
	
	print("Creando nuevo gamelobbyServer - ", gamelobby_name)
	
	var Gamelobby_instance = Gamelobby.instance()
	Gamelobby_instance.set_name(gamelobby_name)
	Gamelobby_instance.set_network_master(1)
	Gamelobby_instance.config = gamelobby_config
	$Gamelobbies.add_child(Gamelobby_instance)
	if isteam == false:
		for a in gamelobby_config["connected_players"]:
			var player : PackedScene = load("res://Characters/Survivor/Survivor.tscn")
			var instancia = player.instance()
			instancia.set_name(str(a))
			instancia.set_network_master(a)
			Gamelobby_instance.add_child(instancia)
	else:
		for a in gamelobby_config["first_team"]:
			var player : PackedScene = load("res://Characters/Survivor/Survivor.tscn")
			var instancia = player.instance()
			instancia.set_name(str(a))
			instancia.set_network_master(a)
			Gamelobby_instance.add_child(instancia)
		for a in gamelobby_config["second_team"]:
			var player : PackedScene = load("res://Characters/Survivor/Survivor.tscn")
			var instancia = player.instance()
			instancia.set_name(str(a))
			instancia.set_network_master(a)
			Gamelobby_instance.add_child(instancia)
		
	return gamelobby_name
	countlobby+=1
	
func join_gamelobby(Player, GameLobby):
	GameLobby.add_child(Player)
	pass
