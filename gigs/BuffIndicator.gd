extends Button
class_name BuffIndicator

var joke_name: String


func _ready():
	Events.choose_joke.connect(_on_choose_joke)
	Events.gig_combat_state_enter.connect(_on_enter_combat_state)
	Events.gig_combat_state_exit.connect(_on_exit_combat_state)


func setup(joke: Joke):
	text = joke.joke_name
	joke_name = joke.joke_name
	pressed.connect(press)


func press():
	disabled = true
	Events.choose_joke.emit(joke_name)


func _on_choose_joke(_joke_name: String):
	print("Disabling button")
	disabled = true


func _on_enter_combat_state(state: Gig.CombatState):
	if state == Gig.CombatState.PLAYER_TURN:
		print("Enabling button")
		disabled = false


func _on_exit_combat_state(state: Gig.CombatState):
	pass
