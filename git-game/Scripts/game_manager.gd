extends Node

# Stores the currently selected GitCard resource
var current_card :GitCard

func select_card(card: GitCard):
	current_card = card
	print(current_card)
