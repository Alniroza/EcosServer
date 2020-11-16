extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	var timer = Timer.new()
	timer.set_name("timer")
	timer.connect("timeout", self, "_on_timer_timeout_1")
	add_child(timer)
	timer.set_wait_time(200)
	timer.start()
	
func _process(delta):
	var time_left = int(get_node("timer").get_time_left())
	var minutes = int(time_left/60)
	var seconds = time_left - minutes * 60
	if seconds < 10 :
		set_text( str(minutes) + " : 0" + str(seconds))
	else :
		set_text( str(minutes) + " : " + str(seconds))
	
func _on_timer_timeout_1():
	print("Se acabó")
	get_node("timer").stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
