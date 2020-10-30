extends Node2D



func _ready():
	pass


remotesync func move(input):
	pass

remote func propagate_move(input):
	#Propagando movimientos
	print("Moviendo a ", get_tree().get_rpc_sender_id(), " hacia ", input)
	rpc("move", input)
	pass
