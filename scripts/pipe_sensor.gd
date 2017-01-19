extends Area2D

func _ready():
	connect("body_enter", self, "on_body_enter")
	
func on_body_enter(other):
	if other.is_in_group(utils.GROUP_BIRD):
		utils.update_score()
