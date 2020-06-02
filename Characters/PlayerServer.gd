extends Node2D

#Esta clase se encarga de recopilar la informacion de un Player cliente y corroborar
#que existe en la BdD. Tiene funcionalidades como enviar mensaje privado, agregar amigos,
#invitar a partida, etc.

#Se debe diferenciar de un Character, que son los personajes que se usan en match. 


var my_id

func _ready():
	pass

remote func create_char(id, gamelobby_name):
#	var survivor_instace = Survivor.instance()
#	survivor_instace.set_name(str(id))
#	get_parent().get_node(gamelobby_name).add_child(survivor_instace)
	
	pass
	
func set_id(id):
	my_id = id
	return 0