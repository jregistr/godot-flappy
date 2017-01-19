extends Node

var FLAPPING_STATE = 0
var FLYING_STATE = 1
var HIT_STATE = 2
var GROUNDED_STATE = 3

var GROUP_PIPES = "pipes"
var GROUP_GROUND = "ground"
var GROUP_BIRD = "bird"

var score = 0
signal score_updated

func get_main_node():
	var root = get_tree().get_root()
	return root.get_child(root.get_child_count() - 1)
	
func cycle(value, max_value):
	value += 1
	if value > max_value:
		value = 0
	return value

func update_score():
	score += 1
	emit_signal("score_updated", score)
