extends Node2D

onready var SurvivorServer = preload("res://Characters/SurvivorServer/SurvivorServer.tscn")

var matchplayers = []

func _ready():
	pass


remote func request_character(charname, player_id):
	print("Se solicita el personaje ", charname)
	matchplayers.append(player_id)
	rpc("create_character", charname, player_id)
	pass
	
remotesync func create_character(charname, player_id):
	print("Sincronizando personaje ", player_id)
	var survivor_instance =  SurvivorServer.instance()
	survivor_instance.set_name(str(player_id))
	survivor_instance.set_position(Vector2(300,300))
	survivor_instance.set_network_master(player_id)
	add_child(survivor_instance)
	pass