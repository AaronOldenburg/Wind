extends RigidBody

const UP: Vector3 = Vector3(0,0,-1)

onready var world = get_node("/root/Main/World")
onready var block_constellation = get_node("/root/Main/Blocks")
onready var radius = world.scale.x

func _ready():
	initialize_position()
	
func initialize_position():
	translation = Vector3.ZERO
	rotation_degrees = Vector3(randi() % 360, randi() % 360, randi() % 360)
	translate(Vector3(0,0,radius))
	call_deferred("reparent")
	
func reparent():
	look_at(world.translation, UP)

func _on_world_released():
	get_parent().remove_child(self)
	block_constellation.add_child(self)


func _on_Block_body_entered(body):
	pass
