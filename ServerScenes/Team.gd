extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var playing = false
var party_information = {} #id : nombre, eleccion
var name_leader
var players = [] # contiene nombres
var party_elections = {}  # nombre : eleccion
var party_number
# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	pass # Replace with function body.

func set_leader(the_name):
	name_leader = the_name
	
func set_party_information(the_name,idplayer, election_player):
	party_information[idplayer] = [the_name,election_player]

func set_roles_by_name(the_name, the_election):
	party_elections[the_name] = the_election
func set_party_number(number):
	party_number = number
func delete(the_name, the_id):
	if players[0] == the_name :
		name_leader = players[1]
	players.erase(the_name)
	party_information.erase(the_id)
	party_elections.erase(the_name)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
