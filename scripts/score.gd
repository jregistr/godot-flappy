extends Label

func _ready():
	utils.connect("score_updated", self, "on_scored")
	pass

func on_scored(score):
	set_text(str(score))
	pass