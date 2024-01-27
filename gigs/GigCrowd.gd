extends Node
class_name GigCrowd

@export_range(0.0, 1.0) var event_rate = 0.5

var crowd_events: Array[CrowdEvent]:
	get:
		var result: Array[CrowdEvent]
		result.assign(N.get_all_children(self, CrowdEvent))
		return result


func take_turn():
	Events.set_debug_message.emit("The crowd is taking a turn...")
	await get_tree().create_timer(1.5).timeout

	if randf() <= event_rate:
		var total_weight = crowd_events.reduce(func(total, evt): return total + evt.weight, 0.0)
		var num = randf_range(0.0, total_weight)
		for event in crowd_events:
			if num > total_weight - event.weight:
				await event.execute()
				break
			total_weight -= event.weight
	else:
		Events.set_debug_message.emit("No crowd events")
		await get_tree().create_timer(1.0).timeout

	Events.crowd_end_turn.emit()


func _ready():
	Events.round_start.connect(_on_round_start)
	Events.gig_combat_state_enter.connect(_on_combat_state_enter)


func _on_round_start():
	pass


func _on_combat_state_enter(state: Gig.CombatState):
	if state == Gig.CombatState.CROWD_TURN:
		take_turn()
