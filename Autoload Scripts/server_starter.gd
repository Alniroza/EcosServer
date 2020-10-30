extends Node

#const SERVER_IP="25.8.187.236"
const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 9000
const MAX_PLAYERS = 100



#Necesitamos cargar la BdD de las cuentas existentes. Por ahora, sera un dicc.
#Futuro podria ser simplemente un Txt
onready var players_database = {
	1: {"username": "server", "password": "dinosaurio", "etc":0},
	2: {"username": "a_player", "password": "happy", "etc":0}
	}
var prueba = [2,3,4]
var new_player={1:[3,1],2:[4,7]}
# Informacion de los jugadores conectados al servidor
var connected_ids = []
var uno = "hola perro - red"
var dos = "hola"
# Nuestra informacion (talvez innecesario)

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



func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	
	#Autorizamos al player
	#TODO
	
	
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
	
