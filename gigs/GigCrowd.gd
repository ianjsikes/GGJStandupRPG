extends Node
class_name GigCrowd

@export_range(0.0, 1.0) var event_rate = 0.5

var crowd_events: Array[CrowdEvent]:
	get:
		var result: Array[CrowdEvent]
		result.assign(N.get_all_children(self, CrowdEvent))
		return result


func take_turn():
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
		pass

	Events.crowd_end_turn.emit()


func _ready():
	Events.round_start.connect(_on_round_start)
	Events.gig_combat_state_enter.connect(_on_combat_state_enter)
	Events.crowd_ineffective.connect(_on_ineffective)
	Events.crowd_supereffective.connect(_on_supereffective)
	Events.crowd_normal_effective.connect(_on_normal_effective)
	Events.crowd_lose_laughs.connect(_on_lose_laughs)
	Events.crowd_supereffective.connect(_on_supereffective)


func _on_round_start():
	get_parent().get_node("BGCrowd").current_mood = "Neutral"
	get_parent().get_node("FGCrowd").current_mood = "Neutral"


func _on_combat_state_enter(state: Gig.CombatState):
	if state == Gig.CombatState.CROWD_TURN:
		take_turn()


func _on_ineffective():
	$SFXCrickets.play()
	get_parent().get_node("BGCrowd").current_mood = "Sad"
	get_parent().get_node("FGCrowd").current_mood = "Sad"
	Events.set_debug_message.emit("The crowd doesn't like that type of joke")


func _on_normal_effective():
	$SFXLaughSmall.play()
	get_parent().get_node("BGCrowd").current_mood = "Happy"
	get_parent().get_node("FGCrowd").current_mood = "Happy"


func _on_lose_laughs():
	$SFXLaughBoo.play()
	get_parent().get_node("BGCrowd").current_mood = "Sad"
	get_parent().get_node("FGCrowd").current_mood = "Sad"


func _on_supereffective():
	$SFXLaughBig.play()
	get_parent().get_node("BGCrowd").current_mood = "Happy"
	get_parent().get_node("FGCrowd").current_mood = "Happy"
	Events.set_debug_message.emit("The crowd loves that type of joke!")
