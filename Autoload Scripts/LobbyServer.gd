extends Node2D

onready var Gamelobby = preload("res://ServerScenes/GameLobbyServer.tscn")
onready var PlayerServer = preload("res://Characters/PlayerServer.tscn")

#¿Que mas deberia tener los players?
onready var PlayersDatabase = [
	{"username" : "goduser", "password" : "goduser"},
	{"username" : "god", "password" : "god"},
	{"username" : "a", "password" : "a"},
	{"username" : "b", "password" : "b"},
	{"username" : "gabriel", "password" : "gabriel"},
	{"username" : "alonso", "password" : "alonso"},
	{"username" : "alex", "password" : "alex"},
	{"username" : "franco", "password" : "franco"},
	{"username" : "Goku", "password" : "Goku"},
	{"username" : "Piñera", "password" : "Piñera"},
	{"username" : "c", "password" : "c"},
	{"username" : "d", "password" : "d"}
	]
	

var new_registered_player={}
var Players_connected={}
var Player_Selection={}  #[id] : nombre,eleccion de personaje

var isparty
var auxcountlobby=1
var countlobby = 1
var lobby_number = 0

#Variable que guardará a los players esperando por encontrar partida
var firsteam
var secondteam
var WaitingMode1 = []
var PlayersWaitingmode1 = {1:[]}
var countmode1 = 1
var WaitingMode2 = []
var PlayersWaitingmode2 = {1:[]}
var countmode2 = 1
var PlayersWaitingmode3 = {1:[]}
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

func Remove_peer(peer_id):
	var someone_kicked = false
	for a in PlayersWaitingmode1:
		if PlayersWaitingmode1[a].has(peer_id):
			PlayersWaitingmode1[a].erase(peer_id)
			someone_kicked = true
	for a in PlayersWaitingmode2:
		if PlayersWaitingmode2[a].has(peer_id):
			PlayersWaitingmode2[a].erase(peer_id)
			someone_kicked = true
	for a in PlayersWaitingmode3:
		if PlayersWaitingmode3[a].has(peer_id):
			PlayersWaitingmode3[a].erase(peer_id)
			someone_kicked = true
	var string_gamelobbies = "GameLobby"
	if someone_kicked != true : 
		print(get_node("Gamelobbies").get_children())
		for a in range(get_node("Gamelobbies").get_child_count()):
			#var Gamelobby = get_node("Gamelobbies").get_node(string_gamelobbies+str(a+1))
			var Gamelobby = get_node("Gamelobbies").get_child(a)
			print(Gamelobby.get_name())
			if (Gamelobby.Players).has(peer_id):
				for b in Gamelobby.Players:
					if peer_id != b:
						$Gamelobbies.remove_peer(b,peer_id,Gamelobby.get_name())
				
		

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
remote func matchmaking(id, gamemode,players,party,player_election,player_name,party_player_election):
	if party == false:
		Player_Selection[id]=[player_name,player_election]
		if gamemode == "survival" :
			if PlayersWaitingmode1.size()>0:
				WaitingMode1=PlayersWaitingmode1[1]
				WaitingMode1.append(id)
				PlayersWaitingmode1[1]=WaitingMode1
			else:
				PlayersWaitingmode1[1]=[id]
		if gamemode == "teamdeathmatch" :
			var joined = false
			var lastkey
			if PlayersWaitingmode2.size()>0:             # Veo si hay algun team ya armandose
				for a in PlayersWaitingmode2.keys():     # Reviso los teams
					lastkey=a
					if PlayersWaitingmode2[a].size()==2:
						pass
					else :
						PlayersWaitingmode2[a].append(id)
						joined=true
				if joined==false:                        #si no ingreso a ningun team, tengo que crear otro
					PlayersWaitingmode2[lastkey+1]=[id]
			else :                                       #no hay ningun team creado, así que lo creo
				PlayersWaitingmode2[1]=[id]
			print("Teamdeathmatch : ", PlayersWaitingmode2)
		if gamemode == "deathmatch" :
			if PlayersWaitingmode3.size()>0:
				WaitingMode3=PlayersWaitingmode3[1]
				WaitingMode3.append(id)
				PlayersWaitingmode3[1]=WaitingMode3
			else:
				PlayersWaitingmode3[1]=[id]
			print("Deathmatch : ", PlayersWaitingmode3)
			
				
	else:
		Player_Selection[id]=[player_name,player_election]
		for d in party_player_election:
			Player_Selection[d]=party_player_election[d]
		if gamemode == "survival" :
			var joined = false
			if PlayersWaitingmode1.size()>0:
				for playersmode1 in PlayersWaitingmode1:
					countmode1=playersmode1
					if PlayersWaitingmode1[playersmode1].size()+players.size()<=3:
						for a in players:
							PlayersWaitingmode1[playersmode1].append(players[a])
							joined=true
				if joined!=true:
					PlayersWaitingmode1[countmode1+1]=players.values()
			else:
				PlayersWaitingmode1[1]=players.values()
		if gamemode == "teamdeathmatch" :
			var joined = false
			if PlayersWaitingmode2.size()>0:
				for playersmode2 in PlayersWaitingmode2:
					countmode2=playersmode2
					if PlayersWaitingmode2[playersmode2].size()+players.size()<=2:
						for a in players:
							PlayersWaitingmode2[playersmode2].append(players[a])
							joined=true
				if joined!=true:
					PlayersWaitingmode2[countmode2+1]=players.values()
			else:
				PlayersWaitingmode2[1]=players.values()
		if gamemode == "deathmatch" :
			var joined = false
			if PlayersWaitingmode3.size()>0:
				for playersmode3 in PlayersWaitingmode3:
					countmode3=playersmode3
					if PlayersWaitingmode3[playersmode3].size()+players.size()<=3:
						for a in players:
							PlayersWaitingmode3[playersmode3].append(players[a])
							joined=true
				if joined!=true:
					PlayersWaitingmode3[countmode3+1]=players.values()
			else:
				PlayersWaitingmode3[1]=players.values()
		countmode1 = 1
		countmode2 = 1
		countmode3 = 1
	if gamemode== "survival":
		for matchmodel1ready in PlayersWaitingmode1:
			if PlayersWaitingmode1[matchmodel1ready].size() == 3:
				new_Gamelobby(gamemode,PlayersWaitingmode1[matchmodel1ready],false)
				PlayersWaitingmode1.erase(matchmodel1ready)
	
	if gamemode == "teamdeathmatch":
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
	if gamemode== "deathmatch":
		for matchmodel3ready in PlayersWaitingmode3:
			if PlayersWaitingmode3[matchmodel3ready].size() == 3:
				new_Gamelobby(gamemode,PlayersWaitingmode3[matchmodel3ready],false)
				PlayersWaitingmode3.erase(matchmodel3ready)

#Les creamos partidas de juego a los jugadores. 
remote func new_Gamelobby(gamemode,players,isteam):
	var gamelobby_name = "GameLobby"+str(countlobby)
	lobby_number = int(countlobby)
	var gamelobby_config = {}
	var team_selection={}  #Contiene a todos los players a los que se va crear la partida
	if isteam == false:
		for a in players:
			team_selection[a]=Player_Selection[a] #team_selection = [id] : nombre,eleccion de personaje
		gamelobby_config = {
			"name": gamelobby_name,
			"gamemode": gamemode,
			"connected_players": players,
			"elo": 0
			}
	elif isteam == true:
		for a in players:
			team_selection[a]=Player_Selection[a]
		gamelobby_config = {
			"name": gamelobby_name,
			"gamemode": gamemode,
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
		if gamemode=="survival":
			Gamelobby_instance.set_players(team_selection.keys())
			for a in gamelobby_config["connected_players"]:
				var player : PackedScene = load("res://Characters/Survivor/Survivor.tscn")
				var instancia = player.instance()
				instancia.set_name(str(a))
				instancia.set_network_master(a)
				Gamelobby_instance.add_child(instancia)
				rpc_id(a,"_Time_to_play_alone",team_selection,gamemode,lobby_number)
		if gamemode=="deathmatch":
			Gamelobby_instance.set_players(team_selection.keys())
			for a in gamelobby_config["connected_players"]:
				var player : PackedScene = load("res://Characters/Survivor/Survivor.tscn")
				var instancia = player.instance()
				instancia.set_name(str(a))
				instancia.set_network_master(a)
				Gamelobby_instance.add_child(instancia)
				rpc_id(a,"_Time_to_play_alone",team_selection,gamemode,lobby_number)
			
	else:
		Gamelobby_instance.set_players(team_selection.keys())
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
		for a in team_selection:
			rpc_id(a,"_Time_to_play_team",team_selection,gamelobby_config["first_team"],gamelobby_config["second_team"],gamemode,lobby_number)
	countlobby+=1
	return gamelobby_name
	
	
func join_gamelobby(Player, GameLobby):
	GameLobby.add_child(Player)
	pass
