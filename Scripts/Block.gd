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
	initialize_audio()

#func _process(delta):
#	if flying:
#		if self.translation.distance_to(world.translation) > world.universe_boundary:
#			freeze()

func initialize_position():
	translation = Vector3.ZERO
	rotation_degrees = Vector3(randi() % 360, randi() % 360, randi() % 360)
	translate(Vector3(0,0,radius))
	call_deferred("reparent")
	
func initialize_audio():
	$AudioLoop.stream = world.block_curr_sound
	randomize()
	$AudioLoop.pitch_scale = rand_range(0.1,2.0)
	
func reparent():
	look_at(world.translation, UP)

func _on_world_released():
	if !affected_by_world:
		return

	randomize()
	$Deferred_changes.wait_time = randf()
	$Deferred_changes.start()
	
	flying = true
	get_parent().remove_child(self)
	block_constellation.add_child(self)
	linear_velocity = -world.angular_velocity * self.rotation * FLING_DAMPING
	
	$EjectSound.pitch_scale = rand_range(0,2)
	$EjectSound.play()
	
	$Destruct_timer.start()
	
	
func _on_Block_body_entered(body):
	if body.is_in_group("blocks"):
		if body.mode == MODE_STATIC:
			freeze()

# Now unused
func freeze():
	flying = false
	mode = RigidBody.MODE_STATIC
	continuous_cd = false
	contacts_reported = 0
#	sleeping = true
	linear_velocity = Vector3.ZERO
	call_deferred("set_contact_monitor", false)
	get_tree().call_group("world", "_on_flung_block_stopped")
	

func _on_Deferred_changes_timeout():
	set_collision_mask_bit(2, true)


func _on_Destruct_timer_timeout():
	get_tree().call_group("world", "_on_flung_block_stopped")
	queue_free()
