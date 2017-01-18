extends Node2D

var scn_ground = preload("res://scenes/ground.tscn")

onready var container = get_node("container")
onready var camera = utils.get_main_node().get_node("camera")

var grounds = []
var bottom_rights = []
var next_bottom_index = 0

var GROUND_WIDTH = 168
var FILL_COUNT = 3

func _ready():
	set_process(true)
	
	for i in range(FILL_COUNT):
		var ground = init_ground()
		grounds.append(ground)
		bottom_rights.append(ground.get_node("bottom_right"))

func _process(delta):
	var bottom = bottom_rights[next_bottom_index]
	if bottom.get_global_pos().x <= camera.total_pos().x:
		var current = grounds[next_bottom_index]
		current.set_pos(get_pos())
		go_to_next()
		increment_next_bottom()

func increment_next_bottom():
	next_bottom_index += 1
	if next_bottom_index > 2:
		next_bottom_index = 0

func init_ground():
	var new_ground = scn_ground.instance()
	new_ground.set_pos(get_pos())
	container.add_child(new_ground)
	go_to_next()
	return new_ground

func go_to_next():
	set_pos(get_pos() + Vector2(GROUND_WIDTH, 0))
