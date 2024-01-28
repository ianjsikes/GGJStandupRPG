extends Control
class_name JokeCard

var joke: Joke
var hovered: bool = false
var disabled: bool = false

@onready var name_label: Label = get_node("%JokeName")
@onready var type_label: Label = get_node("%JokeType")
@onready var description_label: RichTextLabel = get_node("%JokeDescription")

var shown: bool:
	get:
		return get_index() == get_parent().get_child_count() - 1

var highlighted: bool:
	set(value):
		highlighted = value
		if $PanelContainer.material:
			$PanelContainer.material.set_shader_parameter("enabled", value)


func _ready():
	Events.choose_joke.connect(_on_choose_joke)
	Events.gig_combat_state_enter.connect(_on_enter_combat_state)
	Events.gig_combat_state_exit.connect(_on_exit_combat_state)
	if $PanelContainer.material:
		$PanelContainer.material = $PanelContainer.material.duplicate(true)


func setup(_joke: Joke):
	joke = _joke
	name_label.text = joke.joke_name
	type_label.text = Types.joke_type_to_string(joke.joke_type)
	description_label.text = joke.joke_description


func press():
	if GameState.current_gig:
		disabled = true
	highlighted = false
	Events.choose_joke.emit(joke.joke_name)
	Events.hide_tutorial.emit("JokeConfirmTutorial")


func _input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.button_index == MOUSE_BUTTON_LEFT
	):
		if hovered:
			if shown:
				if !disabled:
					press()
			else:
				Events.bring_joke_card_to_front.emit(get_index())


func _on_choose_joke(_joke_name: String):
	if GameState.current_gig:
		print("Disabling button")
		disabled = true


func _on_enter_combat_state(state: Gig.CombatState):
	if state == Gig.CombatState.PLAYER_TURN:
		print("Enabling button")
		disabled = false
		if hovered and shown:
			highlighted = true


func _on_exit_combat_state(state: Gig.CombatState):
	pass


func shuffled():
	if !shown:
		highlighted = false


func _on_mouse_exited():
	hovered = false
	get_parent()._on_mouse_exited()
	highlighted = false


func _on_mouse_entered():
	hovered = true
	get_parent()._on_mouse_entered()
	if shown:
		highlighted = true
