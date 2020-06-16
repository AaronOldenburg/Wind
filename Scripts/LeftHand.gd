extends ARVRController

var trigger_is_pressed : bool = false
#var grip_is_pressed : bool = false


func _ready():
	# hide to begin with
	visible = false

func _process(delta):
	if !get_is_active():
		visible = false
	elif !visible:
		# make it visible
		visible = true

	if is_button_pressed(JOY_VR_TRIGGER) || is_button_pressed(JOY_VR_GRIP):
		if !trigger_is_pressed:
			trigger_is_pressed = true
			get_tree().call_group("interactable", "_on_trigger_pressed", self)
	else:
		if trigger_is_pressed:
			trigger_is_pressed = false
			get_tree().call_group("interactable", "_on_trigger_released", self)
		
	if is_button_pressed(JOY_OCULUS_MENU):
		get_tree().reload_current_scene()
