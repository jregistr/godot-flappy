extends Camera2D

onready var bird = utils.get_main_node().get_node("bird")

func enableCallBacks():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	set_pos(Vector2(bird.get_pos().x, get_pos().y))
	
func total_pos():
	return get_pos() + get_offset()