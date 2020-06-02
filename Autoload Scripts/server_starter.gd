extends Node

const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 9000
const MAX_PLAYERS = 100

onready var PlayerServer = preload("res://Characters/PlayerServer.tscn")

#Necesitamos cargar la BdD de las cuentas existentes. Por ahora, sera un dicc.
#Futuro podria ser simplemente un Txt
onready var players_database = {
	1: {"username": "server", "password": "dinosaurio", "etc":0},
	2: {"username": "server", "password": "dinosaurio", "etc":0}
	}


# Informacion de los jugadores conectados al servidor
var connected_ids = []
# Nuestra informacion (talvez innecesario)
var my_info = { name = "MainServer" }

func _ready():
	#Conectamos señales
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	#Ejecutamos el Servidor.
	var peer = NetworkedMultiplayerENet.new()
	#peer.set_bind_ip(SERVER_IP) #with a real server here?
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print("El servidor esta ON en puerto ", SERVER_PORT)
	pass

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	#Configuramos player
	var player_instance = PlayerServer.instance()
	player_instance.set_name(str(id))
	player_instance.set_network_master(id)
	player_instance.set_id(id)
	
	#Agregamos al Lobby un nuevo Player, si no existe.
	var Lobby = get_parent().get_node("root").get_node("Lobby")
	if(Lobby.connected_players.find(id) == -1): #here previously?
		Lobby.add_child(player_instance)
		Lobby.connected_players.append(id)
	pass
	
func _player_disconnected(id):
#	print(id , " se ha desconectado")
#	player_info.erase(id) # Erase player from info.
#	find_node(str(id), true, false ).queue_free()
	pass

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.
