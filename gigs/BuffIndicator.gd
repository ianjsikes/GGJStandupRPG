extends Control
class_name BuffIndicator

var buff: Buff


func _ready():
	Events.buff_update.connect(_on_buff_update)
	# Events.choose_joke.connect(_on_choose_joke)
	# Events.gig_combat_state_enter.connect(_on_enter_combat_state)
	# Events.gig_combat_state_exit.connect(_on_exit_combat_state)


func setup(_buff: Buff):
	buff = _buff
	update_buff_ui()


func _on_buff_update(_buff: Buff):
	if _buff == buff:
		if buff.timer == 0:
			queue_free()
		else:
			update_buff_ui()


func update_buff_ui():
	var message = buff.name

	if buff.timer > -1:
		message += " - (%s rounds)" % buff.timer

	if buff.counter > 1:
		message += " - [%s stacks]" % buff.counter

	self.text = message

# func press():
# 	disabled = true
# 	Events.choose_joke.emit(joke_name)

# func _on_choose_joke(_joke_name: String):
# 	print("Disabling button")
# 	disabled = true

# func _on_enter_combat_state(state: Gig.CombatState):
# 	if state == Gig.CombatState.PLAYER_TURN:
# 		print("Enabling button")
# 		disabled = false

# func _on_exit_combat_state(state: Gig.CombatState):
# 	pass
