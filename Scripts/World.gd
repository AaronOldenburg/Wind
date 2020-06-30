extends RigidBody

const FRICTION = .98
const TURN_SPEED = 300
const RELEASE_THRESHOLD = 2

onready var block_sounds = [
	"res://Audio/autoloops/back.ogg",
	"res://Audio/autoloops/backwhir.ogg",
	"res://Audio/autoloops/crinkle00.ogg",
	"res://Audio/autoloops/moan00.ogg",
	"res://Audio/autoloops/whir00.wav"
]
var block_curr_sound : AudioStream

export var num_blocks = 10
export var universe_boundary = 10

var hands_in_ball: int = 0
var left_hand_in_ball: bool = false
var right_hand_in_ball: bool = false
var hand_interacting : ARVRController = null
var last_hand_pos : Vector3
var blocks_are_flung : bool = false

var mat_main = preload("res://Graphics/Materials/Body.material")

# For some reason, file_grabber is only seeing .import files, not .ogg
#func _enter_tree():
#	block_sounds = FileGrabber.get_files("res://Audio/autoloops/")
	

func _ready():
	create_blocks(num_blocks)
	pass

func _process(delta):
	self.angular_velocity = angular_velocity * FRICTION
		
	if hand_interacting == null:
		return
	var movement = hand_interacting.translation - last_hand_pos
	self.angular_velocity = Vector3(-movement.y * TURN_SPEED, movement.x * TURN_SPEED, 0)
	last_hand_pos = hand_interacting.translation

func create_blocks(number):
	new_block_sound()
	for n in number:
		var block = preload("res://Scenes/Block.tscn").instance()
		add_child(block)

func _on_Area_body_entered(body):
	if !body.is_in_group("hand"):
		return
	
	if body.is_in_group("left"):
		left_hand_in_ball = true
	elif body.is_in_group("right"):
		right_hand_in_ball = true
	
#	$MeshInstance.material_override = mat_interact

func _on_Area_body_exited(body):
	if !body.is_in_group("hand"):
		return

	if body.is_in_group("left"):
		left_hand_in_ball = false
	elif body.is_in_group("right"):
		right_hand_in_ball = false

	# find out if this is the hand that was interacting, consider releasing sphere (or not)

#	if !left_hand_in_ball && !right_hand_in_ball:
#		$MeshInstance.material_override = mat_main

func _on_trigger_pressed(hand):
	if hand.name == "LeftHand" && left_hand_in_ball:
		hand_interacting = hand
		last_hand_pos = hand.translation
	elif hand.name == "RightHand" && right_hand_in_ball:
		hand_interacting = hand
		last_hand_pos = hand.translation
	
	print ("Hand interacting is ", hand_interacting)

func _on_trigger_released(hand):
	if hand == hand_interacting:
		var release_speed = Vector3.ZERO.distance_to(angular_velocity)
		print("My speed: ", release_speed)
		hand_interacting = null
		
		if release_speed > RELEASE_THRESHOLD:
			get_tree().call_group("blocks", "_on_world_released")
			blocks_are_flung = true
	
func _on_flung_block_stopped():
	if blocks_are_flung:
		create_blocks(num_blocks)
		blocks_are_flung = false

func new_block_sound():
	randomize()
	var nextSound = load(block_sounds[randi() % block_sounds.size()])
	block_curr_sound = nextSound
