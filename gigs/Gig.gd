extends Node
class_name Gig

@export_range(0.0, 100.0) var meter: float = 20.0
var round_counter: int = 0
var meter_success_threshold = 80.0
@export var round_limit: int = 10

var player: GigPlayer

enum CombatState { INTRO, PLAYER_TURN, CROWD_TURN, LOSE, WIN }

var combat_state: CombatState = CombatState.INTRO:
	set(new_state):
		Events.gig_combat_state_exit.emit(combat_state)
		combat_state = new_state
		Events.gig_combat_state_enter.emit(combat_state)


func _ready():
	Events.apply_laughs.connect(_on_apply_laughs)
	Events.choose_joke.connect(_on_choose_joke)
	player = N.get_child(self, GigPlayer)
	GameState.gig_player = player
	GameState.current_gig = self

	Events.meter_update.emit(meter, false)

	Events.gig_begin.emit()

	start_gig()


func start_gig():
	while true:
		round_counter += 1
		if round_counter > round_limit:
			print("END OF ROUNDS!!!")
			break

		Events.round_start.emit()
		combat_state = CombatState.PLAYER_TURN

		await get_tree().process_frame

		print("\nRound %s starting\n" % round_counter)
		await Events.player_end_turn

		await get_tree().create_timer(1.0).timeout

		if meter >= 100.0:
			combat_state = CombatState.WIN
			# TODO: Some special stuff if you win or lose in this way
			return
		elif meter <= 0.0:
			combat_state = CombatState.LOSE
			return

		combat_state = CombatState.CROWD_TURN
		await get_tree().process_frame

		await Events.crowd_end_turn

		Events.round_end.emit()
		await get_tree().process_frame
		print("Round end")
	print("Round limit reached! Final meter: %.2f" % meter)
	Events.set_debug_message.emit("Round limit reached! Final meter: %.2f" % meter)

	if meter >= meter_success_threshold:
		combat_state = CombatState.WIN
	else:
		combat_state = CombatState.LOSE


func _on_apply_laughs(laughs: float):
	var current_meter = meter
	var modded_laughs: float
	if laughs > 0.0:
		modded_laughs = player.get_modded_laughs(laughs)
	else:
		modded_laughs = player.get_modded_defense(laughs)

	meter += modded_laughs

	Events.meter_update.emit(meter, true)
	print(
		(
			"Meter change! Old: %.2f, New: %.2f, Base laughs: %.2f, Modded laughs: %.2f"
			% [current_meter, meter, laughs, modded_laughs]
		)
	)


func _on_choose_joke(joke_name: String):
	print("Choosing joke: %s" % joke_name)
	# TODO: Some sort of game state transition
	player.execute_joke(joke_name)
