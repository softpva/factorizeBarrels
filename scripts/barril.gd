extends Node2D

const ESQUERDA = -1
	
func deslocarEDestruir(ladoFelpudo):
	get_node("Primo").set_text("")
	if ladoFelpudo == ESQUERDA:
		get_node("AnimationPlayer").play("direita")
	else:
		get_node("AnimationPlayer").play("esquerda")