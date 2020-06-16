extends RigidBody

const FRICTION = .98
const TURN_SPEED = 300

export var num_blocks = 10
export var universe_boundary = 10

var hands_in_ball: int = 0
var left_hand_in_ball: bool = false
var right_hand_in_ball: bool = false
var hand_interacting : ARVRController = null
var last_hand_pos : Vector3

var mat_main = preload("res://Graphics/Materials/Body.material")
var mat_interact = preload("res://Graphics/Materials/world-interacting.material")

func _ready():
	create_blocks(num_blocks)

func _process(delta):
	self.angular_velocity = angular_velocity * FRICTION
	
	# ask if trigger pressed
	# find out if trigger pressed corresponds to a hand that is in sphere
	# assign hand_interacting
	# set last_hand_pos
	
	# ask if trigger released
	# find out if trigger released corresponds to a hand that is in sphere
	
	
	if hand_interacting == null:
		return
	var movement = hand_interacting.translation - last_hand_pos
	self.angular_velocity = Vector3(-movement.y * TURN_SPEED, movement.x * TURN_SPEED, 0)
	last_hand_pos = hand_interacting.translation

func create_blocks(number):
	for n in number:
		var block = preload("res://Scenes/Block.tscn").instance()
		add_child(block)

func _on_Area_body_entered(body):
	if !body.is_in_group("hand"):
		return
	
#	hand_interacting = body.get_parent()

	# figure out which hand entered, set its bool
	
#	hands_in_ball+=1
	$MeshInstance.material_override = mat_interact


func _on_Area_body_exited(body):
	if !body.is_in_group("hand"):
		return

#	if body.get_parent() == hand_interacting:
#		hand_interacting = null
		
#	hands_in_ball-=1

	# figure out which hand exited, set its bool
	# find out if this is the hand that was interacting, consider releasing sphere (or not)

	# change the following to ask about each hand's bool
	if hands_in_ball == 0:
		$MeshInstance.material_override = mat_main

func _on_trigger_pressed(hand):
	print (hand.name, " had trigger pressed")

func _on_trigger_released(hand):
	print (hand.name, " had trigger released")
	
func _on_grip_pressed(hand):
	print (hand.name, " had grip pressed")
	
func _on_grip_released(hand):
	print (hand.name, " had grip released")
	
