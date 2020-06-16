extends RigidBody

const UP: Vector3 = Vector3(0,0,-1)
const FLING_DAMPING : float = .5

onready var world = get_node("/root/Main/World")
onready var block_constellation = get_node("/root/Main/Blocks")
onready var radius = world.scale.x

var affected_by_world = true
#var flying = false

func _ready():
	initialize_position()
	
#func _physics_process(delta):
#	if flying:
#		add_force(Vector3(0,0,1), UP)
	
func initialize_position():
	translation = Vector3.ZERO
	rotation_degrees = Vector3(randi() % 360, randi() % 360, randi() % 360)
	translate(Vector3(0,0,radius))
	call_deferred("reparent")
	
func reparent():
	look_at(world.translation, UP)

func _on_world_released():
	if !affected_by_world:
		return
		
	get_parent().remove_child(self)
	block_constellation.add_child(self)
#	apply_central_impulse(self.rotation_degrees
#			* FLING_DAMPING)
	linear_velocity = -world.angular_velocity * self.rotation * FLING_DAMPING
#	add_central_force()
#	flying = true
	
func _on_Block_body_entered(body):
	pass
