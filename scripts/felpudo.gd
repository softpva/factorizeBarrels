extends Node2D

onready var parado = get_node("Parado")
onready var batendo = get_node("Batendo")
onready var tumulo = get_node("Tumulo")
onready var animacao = get_node("Animacao")

const ESQUERDA = -1
const DIREITA = 1
var lado = ESQUERDA

func moverParaEsquerda():
	set_pos(Vector2(150, 1070))
	parado.set_flip_h(false)
	batendo.set_flip_h(false)
	
	tumulo.set_pos(Vector2(-44, 41))
	tumulo.set_flip_h(true)
	lado = ESQUERDA

func moverParaDireita():
	set_pos(Vector2(430, 1070))
	parado.set_flip_h(true)
	batendo.set_flip_h(true)	
	tumulo.set_pos(Vector2(28, 41))
	tumulo.set_flip_h(false)
	lado = DIREITA
	
func bater():
	animacao.play("Bater")
	
func morrer():
	animacao.stop()
	parado.hide()
	batendo.hide()
	tumulo.show()