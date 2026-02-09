extends Node

# Stores the currently selected GitCard resource
var card_array: Array[GitCard] = []

func select_card(card: GitCard):
	card_array.append(card)
	print(card_array)
