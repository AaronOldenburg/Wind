extends RigidBody

#const SPHERICAL_GRAVITY: Vector3 = Vector3(0,0,1000)
const UP: Vector3 = Vector3(0,0,-1)

onready var world = get_node("/root/Main/World")
onready var radius = world.scale.x
#var affected_by_gravity: bool = true

func _ready():
#	look_at(world.translation, UP)
#	call_deferred("initialize_position")
	initialize_position()
	
func initialize_position():
	translation = world.translation
	rotation_degrees = Vector3(90,90,45)
	translate(Vector3(0,0,radius))
	call_deferred("reparent")
	
func reparent():
	get_parent().remove_child(self)
	world.add_child(self)
	look_at(world.translation)

#func _integrate_forces(state):
##	apply_central_impulse(transform.basis.z * -1)
#	if affected_by_gravity:
#		add_central_force(transform.basis.z * -1)
#	pass


func _on_Block_body_entered(body):
	pass
#	affected_by_gravity = false
#	print("no more gravity")
