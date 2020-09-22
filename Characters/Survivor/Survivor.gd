extends KinematicBody2D

var speed = 250
var velocity = Vector2()

func _ready():
	print(get_name() , " listo para el combate")
	rset_config("global_position", MultiplayerAPI.RPC_MODE_PUPPET)

func _physics_process(delta):
	if is_network_master():
		if Input.is_action_pressed("ui_right"):
	#		rpc_id(1, "propagate_move", "ui_right")
			rpc("move", "ui_right")
	pass
	
	
remotesync func move(input, delta = 0):
	if input == "ui_right":
		move_and_slide(Vector2(1,0)*100)
	pass
	
func _on_PosTimerSyncro_timeout():
	if is_network_master():
		rset("global_position", self.position)
	pass # Replace with function body.
