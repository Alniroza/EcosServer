extends Node


const SERVER_IP = "127.0.0.1"
const SERVER_PORT = 9000
const MAX_PLAYERS = 100

onready var PlayerServer = preload("res://Characters/PlayerServer.tscn")

	
# Informacion de los jugadores conectados al servidor
var conected_ids = []
# Nuestra informacion (talvez innecesario)
var my_info = { name = "MainServer" }

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
	#Ejecutamos el Servidor.
	var peer = NetworkedMultiplayerENet.new()
	#peer.set_bind_ip(SERVER_IP)
	peer.create_server(SERVER_PORT, MAX_PLAYERS)
	get_tree().set_network_peer(peer)
	print("El servidor esta ON en puerto ", SERVER_PORT)
	pass

func _player_connected(id):
	print(id , " se ha conectado al Servidor")
	new_player_server(id)
    # Called on both clients and server when a peer connects. Send my info to it.
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

func new_player_server(id):
	var player_instance = PlayerServer.instance()
	player_instance.set_name(str(id))
	player_instance.set_network_master(id)
	player_instance.set_id(id)
	get_parent().get_node("root").get_node("Lobby").add_child(player_instance)
	conected_ids.append(id)
	return 0
