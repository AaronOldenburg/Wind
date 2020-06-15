extends RigidBody

const FRICTION = .98
const TURN_SPEED = 300

var hands_in_ball: int = 0
var hand_interacting : ARVRController = null
var last_hand_pos : Vector3

var mat_main = preload("res://Graphics/Materials/Body.material")
var mat_interact = preload("res://Graphics/Materials/world-interacting.material")

func _process(delta):
	self.angular_velocity = angular_velocity * FRICTION
	
	if hand_interacting == null:
		return
	
	var movement = hand_interacting.translation - last_hand_pos
	self.angular_velocity = Vector3(-movement.y * TURN_SPEED, movement.x * TURN_SPEED, 0)
	
	last_hand_pos = hand_interacting.translation

func _on_Area_body_entered(body):
	hand_interacting = body.get_parent()
	
	hands_in_ball+=1
	$MeshInstance.material_override = mat_interact


func _on_Area_body_exited(body):
	if body.get_parent() == hand_interacting:
		hand_interacting = null
		
	hands_in_ball-=1
#	if hands_in_ball == 0:
#		$MeshInstance.material_override = mat_main


	pass # Replace with function body.


	pass # Replace with function body.
