extends RigidBody

const SPHERICAL_GRAVITY: Vector3 = Vector3(0,0,-5)
const UP: Vector3 = Vector3(0,0,-1)

onready var world = get_node("/root/Main/World")
var affected_by_gravity: bool = true

var vel 

func _ready():
	set_physics_process(true)

func _physics_process(delta):
	if world == null:
		return
	look_at(world.translation, UP)
	if affected_by_gravity:
		add_force(SPHERICAL_GRAVITY, UP)
