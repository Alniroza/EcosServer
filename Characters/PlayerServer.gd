extends Node2D

# Este nodo es una instancia de servidor del jugador. 
# Es el encargado de reenviar las señales recibidas por el servidor a los demas jugadores.
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