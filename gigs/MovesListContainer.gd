extends Control

@export var joke_card_scene: PackedScene
@export var card_stack_offset: Vector2 = Vector2(10.0, 40.0)
@export var shuffle_anim_time: float = 0.2
@export var inactive_distance: float = 250.0

var card_sort_tween: Tween

var shuffled = false
var first_scroll = true


func _ready():
	Events.gig_begin.connect(_initialize_moves)
	child_entered_tree.connect(_handle_child_added)
	child_exiting_tree.connect(_handle_child_removed)
	child_order_changed.connect(_handle_child_order_change)
	Events.bring_joke_card_to_front.connect(_handle_bring_to_front)
	Events.choose_joke.connect(_on_choose_joke)
	Events.gig_combat_state_enter.connect(_on_enter_combat_state)


func _on_choose_joke(_joke_name: String):
	(
		create_tween()
		. tween_property(self, "position:y", position.y + inactive_distance, 0.3)
		. set_trans(Tween.TRANS_SINE)
	)


func _on_enter_combat_state(state: Gig.CombatState):
	if state == Gig.CombatState.PLAYER_TURN:
		(
			create_tween()
			. tween_property(self, "position:y", position.y - inactive_distance, 0.3)
			. set_trans(Tween.TRANS_SINE)
		)


func _handle_child_added(node: Control):
	node.position = card_stack_offset * (get_child_count() - 1)


func _handle_bring_to_front(idx: int):
	shuffled = true
	var moving_card = get_child(idx)
	var shown_card = get_child(-1)
	move_child(moving_card, -1)
	moving_card.shuffled()
	shown_card.shuffled()


func _handle_child_removed(node):
	pass


func _handle_child_order_change():
	if shuffled:
		if first_scroll:
			Events.hide_tutorial.emit("JokeScrollTutorial")
			Events.show_tutorial.emit("JokeConfirmTutorial")
		first_scroll = false
		print("Cards shuffled!")
		if card_sort_tween and card_sort_tween.is_running():
			card_sort_tween.kill()

		card_sort_tween = create_tween()
		card_sort_tween.set_parallel(true)
		card_sort_tween.set_ease(Tween.EASE_OUT)
		card_sort_tween.set_trans(Tween.TRANS_QUAD)

		Sfx.get_node("PaperShuffle").play()

		for i in get_child_count():
			card_sort_tween.tween_property(
				get_child(i), "position", card_stack_offset * i, shuffle_anim_time
			)

	shuffled = false


func _initialize_moves():
	for joke in GameState.gig_player.jokes:
		var joke_card: JokeCard = joke_card_scene.instantiate()
		add_child(joke_card)
		joke_card.setup(joke)


func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		match event.button_index:
			MOUSE_BUTTON_WHEEL_DOWN:
				shuffled = true
				var moving_card = get_child(-1)
				move_child(moving_card, 0)
				moving_card.shuffled()
				print("scroll down")
			MOUSE_BUTTON_WHEEL_UP:
				shuffled = true
				var moving_card = get_child(0)
				move_child(moving_card, -1)
				moving_card.shuffled()
				print("scroll up")
