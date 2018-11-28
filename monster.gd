extends Node2D

# public class member variables go here
export var health_red = 255
export var health_green = 255
export var health_blue = 255
export(float) var SPEED = 10.0
export var type = "horny"

enum STATES { IDLE, FOLLOW }
var _state = null

var path = []
var target_point_world = Vector2()
var target_position = Vector2()

var velocity = Vector2()

func _ready():
	_change_state(IDLE)
	connect("hit", self, "_got_hit")

func _process(delta):
	# update health bars based on internal colour health value
	$Healthbars/HealthbarRed.set_value((self.health_red / 255.0) * 100)
	$Healthbars/HealthbarGreen.set_value((self.health_green / 255.0) * 100)
	$Healthbars/HealthbarBlue.set_value((self.health_blue / 255.0) * 100)
	# update sprite modulation based on color health value
	$Sprite.set_self_modulate( Color((health_red / 255.0), (health_green / 255.0), (health_blue / 255.0), 1) )
	
	if not _state == FOLLOW:
		return
	var arrived_to_next_point = _move_to(target_point_world)
	if arrived_to_next_point:
		path.remove(0)
		if len(path) == 0:
			_change_state(IDLE)
			return
		target_point_world = path[0]
	
	if _state == FOLLOW:
		if velocity.angle() >= -PI/4 && velocity.angle() <= PI/4:
			$Sprite/AnimationPlayer.play("walk_right")
		elif velocity.angle() <= -PI/4 && velocity.angle() >= -0.75*PI:
			$Sprite/AnimationPlayer.play("walk_up")
		elif abs(velocity.angle()) >= 0.75*PI:
			$Sprite/AnimationPlayer.play("walk_left")
		elif velocity.angle() <= 0.75*PI && velocity.angle() >= PI/4:
			$Sprite/AnimationPlayer.play("walk_down")
		
		
func _change_state(new_state):
	if new_state == FOLLOW:
		path = get_parent().get_node('NavMap').get_path(position, target_position)
		if not path or len(path) == 1:
			_change_state(IDLE)
			return
		# The index 0 is the starting cell
		# we don't want the character to move back to it in this example
		target_point_world = path[1]
	_state = new_state
	
func _move_to(world_position):
	var MASS = 10.0
	var ARRIVE_DISTANCE = 10.0
	var desired_velocity = (world_position - position).normalized() * SPEED
	var steering = desired_velocity - velocity
	velocity += steering / MASS
	position += velocity * get_process_delta_time()
	return position.distance_to(world_position) < ARRIVE_DISTANCE

func _input(event):
	if event.is_action_pressed('click'):
		if Input.is_key_pressed(KEY_SHIFT):
			global_position = get_global_mouse_position()
		else:
			target_position = get_global_mouse_position()
		_change_state(FOLLOW)
	
func move_to(world_position):
	target_position = world_position
	_change_state(FOLLOW)
		
func _got_hit(body, damage):
	print("I got hit")
	
func set_type(type):
	self.type = type

func set_speed(speed):
	self.SPEED = speed