class_name CardManager
extends Control

signal card_selected(card: GitCard)

# Drag your GitCard resources here in the Inspector
@export var card_pool: Array[GitCard]
# Assign a container (e.g., HBoxContainer) to hold the 3 cards
@export var cards_container: Container
# Assign a scene that represents a single card (Button or TextureRect)
@export var card_display_scene: PackedScene
# Optional: Force a specific size for the cards (e.g., 160x240). Leave at 0,0 to use scene default.
@export var forced_card_size: Vector2 = Vector2.ZERO

var current_selection: GitCard

func get_selected_card() -> GitCard:
	return current_selection

func present_choice():
	# Ensure UI is visible
	cards_container.visible = true
	# self.visible = true # Uncomment if hiding the whole control

	# 1. Clear previous cards
	for child in cards_container.get_children():
		child.queue_free()
	
	# 2. Shuffle and pick 3 unique cards
	if card_pool.size() < 3:
		printerr("Not enough cards in the pool to pick 3!")
		return
	
	var deck = card_pool.duplicate()
	deck.shuffle()
	var hand = deck.slice(0, 3)
	
	print("Picking ", hand.size(), " cards from pool of ", deck.size())
	
	# 3. Instantiate and display
	for i in range(hand.size()):
		var card_data = hand[i]
		if card_data == null:
			printerr("Card index ", i, " is null! Check Inspector.")
			continue
			
		var card_instance = card_display_scene.instantiate()
		cards_container.add_child(card_instance)
		
		# Apply forced size if set
		if forced_card_size != Vector2.ZERO:
			if card_instance is Control:
				card_instance.custom_minimum_size = forced_card_size
				# Ensure textures allow resizing
				if card_instance is TextureButton:
					card_instance.ignore_texture_size = true
					card_instance.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		
		# Setup visual data
		if card_instance.has_method("setup"):
			card_instance.setup(card_data)
			
		# Connect the press event
		if card_instance.has_signal("pressed"):
			card_instance.pressed.connect(_on_card_pressed.bind(card_data))
		elif card_instance.has_signal("gui_input"):
			# Fallback for TextureRect or other Controls
			card_instance.gui_input.connect(func(event):
				if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					_on_card_pressed(card_data)
			)

func _on_card_pressed(card: GitCard):
	current_selection = card
	print("Player selected: ", card.command_name)
	card_selected.emit(card)
	
	# Hide the UI
	cards_container.visible = false
	# If this script is on the root Control overlay, you might want:
	# self.visible = false 
	
	# Update Global State
	# Ensure you have added game_manager.gd as an AutoLoad named 'GameManager'
	if has_node("/root/GameManager"):
		get_node("/root/GameManager").select_card(card)
	else:
		printerr("GameManager AutoLoad not found! Please add game_manager.gd to Project Settings > Globals.")
