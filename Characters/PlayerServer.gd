extends Node2D

#Esta clase se encarga de recopilar la informacion de un Player cliente y server
#Tiene funcionalidades como enviar agregar amigos, aceptar partida
#invitar a partida, etc.

#Se debe diferenciar de un Character, que son los personajes que se usan en match. 

#TODO Guardar una identificacion unica de cada jugador en el servidor
#que contenga informacion personal (pass, nombre, correo) y estadisticas del jugador.
#UNA BASE DE DATOS, PUEDE SER UN TXT

var id
var username
var scores

func _ready():
	pass

remote func create_char(id, gamelobby_name):
#	var survivor_instace = Survivor.instance()
#	survivor_instace.set_name(str(id))
#	get_parent().get_node(gamelobby_name).add_child(survivor_instace)
	
	pass
	