extends RayCast3D

func check_interaction() -> void:
	# If raycast detects interactable and interact key is pressed, start interaction
	if is_colliding() && Input.is_action_just_pressed("interact"):
		var collider = get_collider()
		if collider is Interactable:
			collider.start_interaction()
