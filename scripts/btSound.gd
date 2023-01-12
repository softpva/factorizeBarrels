extends TextureButton

onready var btOn = preload("res://assets/speakerOn300px.png")
onready var btOff = preload("res://assets/speakerOff300px.png")
var isOn

func _ready():
	isOn = true
	set_process_input(true)

func _input_event(event):
	if is_pressed() and isOn:
		print("som off")
		set_normal_texture(btOff)
		get_owner().som = get_owner().SEM_SOM
		isOn = false
	elif is_pressed() and !isOn:
		print("som on")
		set_normal_texture(btOn)
		get_owner().som = get_owner().COM_SOM
		isOn = true