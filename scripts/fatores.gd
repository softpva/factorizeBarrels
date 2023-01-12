extends Node2D
var tipo setget setTipo



func _ready():
	pass
	
func setText(txt):
	get_node("sprite/label").set_text(txt)
	
func getText():
	return get_node("sprite/label").get_text()

	
func setTipo(val):
	if val == 1:
		get_node("sprite").set_texture(load("res://assets/white64x64.png"))
		get_node("sprite").set_pos(Vector2(0,0))
		tipo=val

	elif val == 2:
		get_node("sprite").set_texture(load("res://assets/white64x64le.png"))
		get_node("sprite").set_pos(Vector2(64,0))
		tipo=val
	elif val == 3:
		get_node("sprite").set_texture(load("res://assets/white64x64.png"))
		get_node("sprite").set_pos(Vector2(0,0))
		get_node("sprite").set_scale(Vector2(2,1))
		get_node("sprite/label").set_align(0)
		get_node("sprite/label").set_text("B U M")
		tipo=val