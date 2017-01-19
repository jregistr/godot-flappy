extends Node2D

var preload_pipe = preload("res://scenes/pipes.tscn")

onready var container = get_node("container")
onready var camera = utils.get_main_node().get_node("camera")

var pipes = []
var bottom_rights = []
var next_bottom_index = 0

var DISTANCE = 65
var PIPE_WIDTH = 20
var FILL_COUNT = 3
var TOP_OFFSET = 55
var GROUND_HEIGHT = 50

func _ready():
	var bird = utils.get_main_node().get_node("bird")
	if bird:
		bird.connect("state_changed", self, "on_bird_state_changed")
	pass

func _process(delta):
	var bottom = bottom_rights[next_bottom_index]
	if bottom.get_global_pos().x <= camera.total_pos().x:
		var pipe = pipes[next_bottom_index]
		pipe.set_pos(get_pos())
		go_to_next()
		next_bottom_index = utils.cycle(next_bottom_index, FILL_COUNT - 1)

func start():
	set_process(true)
	init_position()
	for i in range(FILL_COUNT):
		var pipe = init_pipe()
		pipes.append(pipe)
		bottom_rights.append(pipe.get_node("bottom_right"))

func on_bird_state_changed(state_id):
	if state_id == utils.FLAPPING_STATE:
		start()

func init_pipe():
	var new_pipe = preload_pipe.instance()
	new_pipe.set_pos(get_pos())
	container.add_child(new_pipe)
	go_to_next()
	return new_pipe

func init_position():
	set_pos(Vector2(camera.total_pos().x + (get_viewport_rect().size.width * 1.2) + PIPE_WIDTH, rand_y_position()))

func rand_y_position():
	randomize()
	return rand_range(TOP_OFFSET, get_viewport_rect().size.height - GROUND_HEIGHT - TOP_OFFSET)

func go_to_next():
	var x = get_pos().x + PIPE_WIDTH + DISTANCE
	var y = rand_y_position()
	set_pos(Vector2(x,y))
