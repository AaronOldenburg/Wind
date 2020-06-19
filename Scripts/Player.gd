extends ARVROrigin

const EDGE_OF_WORLD = 2

func _process(delta):
	if $ARVRCamera.translation.distance_to(Vector3.ZERO) > EDGE_OF_WORLD:
		if !$EdgeLoop.playing:
			$EdgeActions.play("FadeIn")
	else:
		if $EdgeLoop.playing:
			$EdgeActions.play("FadeOut")

func _on_FadeOut_end():
	$EdgeLoop.stop()
