extends RigidBody2D
var damage = Color(10,10,10)
var vel = 100.0
signal hit(body, damage)

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(1)
	connect("hit", self, "contact")

func _fixed_process(delta):
	pass

func shoot(start,goal):
	var x = (goal-start).normalized()
	var y = Vector2(x.y, -x.x)
	set_transform(Transform2D(x,y,start))
	set_linear_velocity(x*vel)
    
func contact(body):
	if body.is_in_group("enemy"):
		emit_signal("hit", body, damage)
		destroy()
    
func destroy():
	#play explosion animation and sound
	queue_free()
    
func _on_Timer_timeout():
	#Destroy after short time in case it never hits anything
	destroy()