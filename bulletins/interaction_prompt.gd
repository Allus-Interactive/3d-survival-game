extends Bulletin

var prompt_text : String = ""

func initialize(prompt) -> void:
	if prompt is String:
		prompt_text = prompt

func _ready() -> void:
	$Label.text = prompt_text
