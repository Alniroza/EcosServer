extends Node2D

onready var Gamelobby = preload("res://ServerScenes/GameLobbyServer.tscn")
onready var PlayerServer = preload("res://Characters/PlayerServer.tscn")
onready var Team = preload ("res://ServerScenes/Team.tscn")
onready var Player_scene = preload ("res://ServerScenes/Player.tscn")

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
var Players_name = {} # id : nombre

var party_number = 1
var party_order = []
var party_information = {}
var created_parties = {}
var isparty
var auxcountlobby=1
var countlobby = 1
var lobby_number = 0
var players_in_party = []
var leaderboard_scores = {}

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

class MyCustomSorter:
	static func sort_ascending(a, b):
		if a[0] > b[0]:
			return true
		return false


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
	if someone_kicked != true : # Eliminar lobby
		for a in range(get_node("Gamelobbies").get_child_count()):
			var Gamelobby = get_node("Gamelobbies").get_child(a)
			if (Gamelobby.Players).has(peer_id):
				for b in Gamelobby.Players:
					if peer_id != b:
						$Gamelobbies.remove_peer(b,peer_id,Gamelobby.get_name())
	if players_in_party.has(peer_id):
		players_in_party.erase(Players_name[peer_id])
		for team in get_node("Team").get_children():
			if team.players.has(Players_name[peer_id]):
				team.delete(Players_name[peer_id],peer_id)
				for players in team.players:
					rpc_id(Players_connected[players],"someone_leave_party",team.players, team.party_elections, team.party_information,Players_name[peer_id])
				print(team.players.size())
				if team.players.size() == 1 :
					print("Team eliminado : ", team.get_name())
					team.queue_free()
	print(Players_connected)
	print("Eliminé al peer : "+ Players_name[peer_id])
	Players_connected.erase(Players_name[peer_id])
	Players_name.erase(peer_id)
	
remote func invite_player_party(name_player_invited,id_sender,name_sender, sender_election,gamemode):
	var invite = true
	if Players_connected.has(name_player_invited) == false:
		rpc_id(int(id_sender),"player_not_connected")
	else :
		if players_in_party.has(Players_connected[name_player_invited]):
			rpc_id(id_sender,"player_is_in_party",name_player_invited)
		else:
			rpc_id(int(Players_connected[name_player_invited]),"_Receive_invitation",name_sender,id_sender, sender_election,gamemode)
	pass

remote func party_answer(answer, name_invited_player, invited_election , name_sender, id_sender, sender_election):	
	var hehasgroup = false
	var number
	if answer == true:
		var string_team = "Team"
		if get_node(string_team).get_child_count() != 0:
			for teams in get_node(string_team).get_children():
				if (teams.players).has(name_sender):
					(teams.players).append(name_invited_player)
					(teams.party_information)[Players_connected[name_invited_player]] = [name_invited_player, invited_election]
					(teams.party_elections)[name_invited_player] = invited_election
					hehasgroup = true
					if players_in_party.has(Players_connected[name_invited_player]) != true :
						players_in_party.append(Players_connected[name_invited_player])
					for a in teams.players:
						print("Envio " , teams.players, teams.party_information, teams.party_elections)
						rpc_id(int(Players_connected[a]),"party_change", teams.players, teams.party_information, teams.party_elections,teams.party_number)
					break
		if hehasgroup == false :
			if players_in_party.has(id_sender) != true:
				players_in_party.append(id_sender)
			if players_in_party.has(Players_connected[name_invited_player]) != true:
				players_in_party.append(Players_connected[name_invited_player])
			var team = Team.instance()
			print("Team creado : "+ string_team + str(party_number))
			team.set_name(string_team+str(party_number))
			team.set_leader(name_sender)
			team.set_party_information(name_sender,id_sender,sender_election)
			team.set_party_information(name_invited_player,Players_connected[name_invited_player],invited_election)
			team.set_roles_by_name(name_sender, sender_election)
			team.set_roles_by_name(name_invited_player, invited_election)
			team.set_party_number(party_number)
			team.players.append(name_sender)
			team.players.append(name_invited_player)
			$Team.add_child(team)
			rpc_id(int(Players_connected[name_sender]),"party_change", team.players, team.party_information, team.party_elections, party_number)
			rpc_id(int(Players_connected[name_invited_player]),"party_change", team.players, team.party_information, team.party_elections, party_number)
			party_number += 1
			
	else : 
		rpc_id(int(id_sender),"no_party_change")
		pass
		
remote func change_character(name_player,id_player, character_election):
	for teams in get_node("Team").get_children():
		if teams.players.has(name_player):
			teams.party_elections[name_player] = character_election
			teams.party_information[id_player] = [teams.party_information[id_player][0], character_election]
			for a in teams.players:
				rpc_id(int(a), "change_character", name_player, character_election, teams.party_information)
			break
remote func leave_party(name_player,id_player, the_party_number):
	print("El numero de la party es : ", the_party_number)
	var the_team = get_node("Team/Team"+str(the_party_number))
	the_team.delete(name_player,id_player)
	players_in_party.erase(id_player)
	for players in the_team.players:
		rpc_id(Players_connected[players],"someone_leave_party",the_team.players, the_team.party_elections, the_team.party_information, name_player)
		if the_team.players.size() == 1 :
			print("Team eliminado : ", the_team.get_name())
			players_in_party.erase(Players_connected[the_team.players[0]])
			the_team.queue_free()
	pass
remote func change_gamemode(the_gamemode, the_party_number):
	var team = get_node("Team/Team"+str(the_party_number))
	for players in team.players:
		rpc_id(Players_connected[players],"change_gamemode",the_gamemode)
func update_leaderboard(name_gamemode, places):
	if name_gamemode == "survival":
		for a in places :
			if leaderboard_scores.has(a) == true:
				leaderboard_scores[str(a)] = leaderboard_scores[str(a)] + places.size()*10 - places.find(a)*10
			else:
				leaderboard_scores[str(a)] = places.size()*10 - places.find(a)*10
	if name_gamemode == "deathmatch":
		for a in places :
			if leaderboard_scores.has(a) == true:
				if int(places[a][0])*6 > int(places[a][1])*2 : 
					leaderboard_scores[str(a)] = leaderboard_scores[str(a)] + int(places[a][0])*6 - int(places[a][1])*2
			else:
				if int(places[a][0])*6 > int(places[a][1])*2 : 
					leaderboard_scores[str(a)] = int(places[a][0])*6 - int(places[a][1])*2
				else:
					leaderboard_scores[str(a)] = 0
	if name_gamemode == "teamdeathmatch":
		if places.has("tie"):
			for a in places["tie"]:
				if leaderboard_scores.has(str(a)) == true:
					leaderboard_scores[str(a)] = leaderboard_scores[str(a)] + 50
				else:
					leaderboard_scores[str(a)] = 40
		else:
			for a in places["winner_team"]:
				if leaderboard_scores.has(str(a)) == true:
					leaderboard_scores[str(a)] = leaderboard_scores[str(a)] + 60
				else:
					leaderboard_scores[str(a)] = 60
			for a in places["loser_team"]:
				if leaderboard_scores.has(str(a)) == true:
					leaderboard_scores[str(a)] = leaderboard_scores[str(a)] + 20
				else:
					leaderboard_scores[str(a)] = 20
				
			
remote func give_leaderboard(id_request):
	var request_scores = []
	var leaderboard_aux = []
	for a in leaderboard_scores:
		print("give_leaderboard : ", leaderboard_scores[a])
		print("give_leaderboard : ", a)
		leaderboard_aux.append([leaderboard_scores[a],a])
	leaderboard_aux.sort_custom(MyCustomSorter, "sort_ascending")
	print("give_leaderboard : " , leaderboard_aux)
	request_scores = [leaderboard_scores[Players_name[id_request]],Players_name[id_request]]
	rpc_id(id_request,"leaderboard_results", leaderboard_aux, request_scores)
	


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
remote func ready_to_play(peer_name, peer_id, team_number):
	var team = get_node("Team/Team"+str(team_number))
	for players in team.players:
		rpc_id(Players_connected[players],"someone_is_ready", peer_name, peer_id, team.players)
	


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
			Players_name[player_id] = str(username)
			if leaderboard_scores.has(username) != true:
				leaderboard_scores[username] = 0
			if get_node("Players").has_node(str(username)) != true:
				var instanced_player = Player_scene.instance()
				instanced_player.set_name_player(username)  #
				instanced_player.set_id_player(player_id)	#
				instanced_player.set_lvl_player(1)          #
				get_node("Players").add_child(instanced_player) #
			else : #
				get_node(str(username)).set_id_player(player_id)#
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
			if PlayersWaitingmode1[matchmodel1ready].size() == 2:
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
			if PlayersWaitingmode3[matchmodel3ready].size() == 2:
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
				rpc_id(a,"_Time_to_play_survival",team_selection,gamemode,lobby_number)
		if gamemode=="deathmatch":
			Gamelobby_instance.set_players(team_selection.keys())
			for a in gamelobby_config["connected_players"]:
				var player : PackedScene = load("res://Characters/Survivor/Survivor.tscn")
				var instancia = player.instance()
				instancia.set_name(str(a))
				instancia.set_network_master(a)
				Gamelobby_instance.add_child(instancia)
				rpc_id(a,"_Time_to_play_deathmatch",team_selection,gamemode,lobby_number, 60)
				rpc_id(a,"_Time_to_play_deathmatch",team_selection,gamemode,lobby_number, 24)
			
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
			rpc_id(a,"_Time_to_play_teamdeathmatch",team_selection,gamelobby_config["first_team"],gamelobby_config["second_team"],gamemode,lobby_number,20)
			rpc_id(a,"_Time_to_play_teamdeathmatch",team_selection,gamelobby_config["first_team"],gamelobby_config["second_team"],gamemode,lobby_number,43)
	countlobby+=1
	return gamelobby_name
	
	
func join_gamelobby(Player, GameLobby):
	GameLobby.add_child(Player)
	pass
