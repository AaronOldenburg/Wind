extends RigidBody

const UP: Vector3 = Vector3(0,0,-1)
const FLING_DAMPING : float = .5

onready var world = get_node("/root/Main/World")
onready var block_constellation = get_node("/root/Main/Blocks")
onready var radius = world.scale.x

var affected_by_world = true
var flying = false

func _ready():
	initialize_position()

func _process(delta):
	if flying:
		if self.translation.distance_to(world.translation) > world.universe_boundary:
			freeze()
#			linear_velocity = Vector3.ZERO
#			angular_velocity = Vector3.ZERO
#			axis_lock_angular_x = true
#			axis_lock_angular_y = true
#			axis_lock_angular_z = true
#			axis_lock_linear_x = true
#			axis

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

	set_collision_mask_bit(2, true)
	get_parent().remove_child(self)
	block_constellation.add_child(self)
	linear_velocity = -world.angular_velocity * self.rotation * FLING_DAMPING
	flying = true
	
func _on_Block_body_entered(body):
	if body.is_in_group("blocks"):
		if body.mode == MODE_STATIC:
			freeze()

func freeze():
	flying = false
	mode = RigidBody.MODE_STATIC
	contact_monitor = false
	contacts_reported = 0
	get_tree().call_group("world", "_on_flung_block_stopped")
	
