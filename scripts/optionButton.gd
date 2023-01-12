extends OptionButton


func _ready():
	add_item("Desligar Som", 1)


func _on_OptionButton_item_selected( ID ):
	if ID == 1 :
		if get_item_text(1) == "Desligar Som":
			get_owner().som = get_owner().SEM_SOM
			set_item_text(1, "Ligar Som")
		else:
			set_item_text(1, "Desligar Som")
			get_owner().som = get_owner().COM_SOM
