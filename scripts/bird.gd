#Script:Bird

extends RigidBody2D

onready var state = FlyingState.new(self)

func _ready():
	add_to_group(utils.GROUP_BIRD)
	set_fixed_process(true)
	set_process_input(true)
	connect("body_enter", self, "on_collided")

func _fixed_process(delta):
	state.update(delta)
	
func _input(event):
	state.input(event)
	
signal state_changed

func set_state(id):
	if id == utils.FLAPPING_STATE:
		state.exit()
		state = FlappingState.new(self)
	elif id == utils.FLYING_STATE:
		state.exit()
		state = FlyingState.new(self)
	elif id == utils.HIT_STATE:
		state.exit()
		state = HitState.new(self)
	elif id == utils.GROUNDED_STATE:
		state.exit()
		state = GroundState.new(self)
	emit_signal("state_changed", id)

func get_state():
	if state extends FlappingState:
		utils.FLAPPING_STATE
	elif state extends FlyingState:
		utils.FLYING_STATE
	elif state extends HitState:
		utils.HIT_STATE
	elif state extends GroundState:
		utils.GROUNDED_STATE

func on_collided(other):
	if state.has_method("on_collided"):
		state.on_collided(other)

#---------------------------------------------------------------------------

class FlyingState:
	
	var bird
	var anim
	var grav_scale
	
	func _init(bird):
		self.bird = bird
		anim = self.bird.get_node("anim")
		anim.play("flying")
		grav_scale = bird.get_gravity_scale()
		bird.set_gravity_scale(0)
		bird.set_linear_velocity(Vector2(50, bird.get_linear_velocity().y))

	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		bird.set_gravity_scale(grav_scale)
		anim.stop()
		bird.get_node("anim_sprite").set_pos(Vector2(0, 0))


#-------------------------------------------------------------------------

class FlappingState:
	
	var bird
	var anim
	
	func _init(bird):
		self.bird = bird
		anim = bird.get_node("anim")
		self.bird.set_linear_velocity(Vector2(50, self.bird.get_linear_velocity().y))
		flap()

	func update(delta):
		if rad2deg(bird.get_rot()) > 30:
			bird.set_rot(deg2rad(30))
			bird.set_angular_velocity(0)
		
		if bird.get_linear_velocity().y > 0:
			bird.set_angular_velocity(1.5)
	
	func input(event):
		if event.is_action_pressed("flap"):
			flap()
	
	func exit():
		pass

	func flap():#{
		bird.set_linear_velocity(Vector2(bird.get_linear_velocity().x, -150))
		bird.set_angular_velocity(-3)
		anim.play("flap")
#	}

	func on_collided(other):
		if other.is_in_group(utils.GROUP_PIPES):
			bird.set_state(utils.HIT_STATE)
		elif other.is_in_group(utils.GROUP_GROUND):
			bird.set_state(utils.GROUNDED_STATE)

#-------------------------------------------------------------

class HitState:
	
	var bird
	
	func _init(bird):
		self.bird = bird 
		bird.set_linear_velocity(Vector2(0, 0))
		bird.set_angular_velocity(2)
		var other = bird.get_colliding_bodies()[0]
		bird.add_collision_exception_with(other)

	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass
	
	func on_collided(other):
		if other.is_in_group(utils.GROUP_GROUND):
			bird.set_state(utils.GROUNDED_STATE)

#----------------------------------------------------------------------

class GroundState:
	
	var bird
	
	func _init(bird):
		print("ground state")
		self.bird = bird

	func update(delta):
		pass
	
	func input(event):
		pass
	
	func exit():
		pass
