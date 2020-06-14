extends Area

var mat_main = preload("res://Graphics/Materials/Body.material")
var mat_interact = preload("res://Graphics/Materials/world-interacting.material")

func _on_World_body_entered(body):
	if body.is_class("CollisionShape"):
		$MeshInstance.material_override = mat_interact


func _on_World_body_exited(body):
	$MeshInstance.material_override = mat_main
