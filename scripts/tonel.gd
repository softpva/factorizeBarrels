extends Node2D

const ESQUERDA = -1
const INIMIGO_DIREITO = 1
const INIMIGO_ESQUERDO = -1
const AMIGO = 0
var tipo = AMIGO setget setSpriteTexture



func deslocarEDestruir(ladoFelpudo):
	get_node("Primo").set_text("")
	if ladoFelpudo == ESQUERDA:
		get_node("AnimationPlayer").play("direita")
	else:
		get_node("AnimationPlayer").play("esquerda")

func absorver():
	get_node("Primo").set_text("")
	get_node("AnimationPlayer").play("absorver")


func setSpriteTexture(newTipo):
	if newTipo == INIMIGO_ESQUERDO:
		get_node("Sprite").set_texture(preload("res://assets/inimigoEsq.png"))
	elif newTipo == INIMIGO_DIREITO:
		get_node("Sprite").set_texture(preload("res://assets/inimigoDir.png"))
	else:
		print(get_node("Sprite").get_texture())
		get_node("Sprite").set_texture(preload("res://assets/barril.png"))

