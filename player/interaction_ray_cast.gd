extends RayCast3D

var is_looking : bool = false

func check_interaction() -> void:
	# If raycast detects interactable and interact key is pressed, start interaction
	if is_colliding():
		var collider = get_collider()
		if not collider is Interactable:
			return
		
		if Input.is_action_just_pressed("interact"):
			collider.start_interaction()
		
		if not is_looking:
			is_looking = true
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.InteractionPrompt, collider.prompt)
	elif is_looking:
		is_looking = false
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.InteractionPrompt)
