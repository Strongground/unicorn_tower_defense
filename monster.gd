extends Node2D

signal hit

# public class member variables go here
export(Color) var health = Color(1,1,1)
export(float) var SPEED = 10.0
export var type = "horny"

enum STATES { IDLE, WALKING }
var _state = null

var path = []
var target_point_world = Vector2()
var target_position = Vector2()

var velocity = Vector2()

func _ready():
	_change_state(IDLE)
	# connect("hit", self, "_got_hit")

func _process(delta):
	# update health bars based on internal colour health value
	$Healthbars/HealthbarRed.set_value(self.health.r * 100)
	$Healthbars/HealthbarGreen.set_value(self.health.g * 100)
	$Healthbars/HealthbarBlue.set_value(self.health.b * 100)
	# update sprite modulation based on color health value
	$Sprite.set_self_modulate( Color((self.health.r), (self.health.g), (self.health.b), 1) )
	
	if self.health.r <= 0 and self.health.g <= 0 and self.health.b <= 0:
		self._ded()
	
	if not _state == WALKING:
		return
	var arrived_to_next_point = _move_to(target_point_world)
	if arrived_to_next_point:
		path.remove(0)
		if len(path) == 0:
			_change_state(IDLE)
			return
		target_point_world = path[0]

	if _state == WALKING:
		if velocity.angle() >= -PI/4 && velocity.angle() <= PI/4:
			$Sprite/AnimationPlayer.play("walk_right")
		elif velocity.angle() <= -PI/4 && velocity.angle() >= -0.75*PI:
			$Sprite/AnimationPlayer.play("walk_up")
		elif abs(velocity.angle()) >= 0.75*PI:
			$Sprite/AnimationPlayer.play("walk_left")
		elif velocity.angle() <= 0.75*PI && velocity.angle() >= PI/4:
			$Sprite/AnimationPlayer.play("walk_down")

func _ded():
	self.queue_free()

func _change_state(new_state):
	if new_state == WALKING:
		path = get_parent().get_node('NavMap').get_path(position, target_position)
		if not path or len(path) == 1:
			_change_state(IDLE)
			return
		# The index 0 is the starting cell
		# we don't want the character to move back to it in this example
		target_point_world = path[1]
	_state = new_state

func _move_to(world_position):
	var ARRIVE_DISTANCE = 10.0
	var desired_velocity = (world_position - position).normalized() * SPEED
	var steering = desired_velocity - velocity
	velocity += steering
	position += velocity * get_process_delta_time()
	return position.distance_to(world_position) < ARRIVE_DISTANCE

# Debug function
func _input(event):
	if event.is_action_pressed('click'):
		if Input.is_key_pressed(KEY_SHIFT):
			global_position = get_global_mouse_position()
		else:
			target_position = get_global_mouse_position()
		_change_state(WALKING)

func move_to(world_position):
	target_position = world_position
	_change_state(WALKING)

func _got_hit(damage):
#	print("I got hit! Removing "+str(damage.r)+" of "+str(self.health.r)+" red health points, and "+str(damage.g)+" of "+str(self.health.g)+" green health points, and "+str(damage.b)+" of "+str(self.health.b)+" blue health points!")
#	print("Received "+str(damage))
	self.health.r = self.health.r - damage.r
	self.health.g = self.health.g - damage.g
	self.health.b = self.health.b - damage.b

func set_type(type):
	self.type = type

func set_speed(speed):
	self.SPEED = speed
