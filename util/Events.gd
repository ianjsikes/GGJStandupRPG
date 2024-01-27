extends Node

signal apply_laughs(laughs: float)
signal round_end
signal round_start
signal choose_joke(joke_name: String)
signal gig_begin

signal player_end_turn
signal crowd_end_turn
signal set_debug_message(message: String)
signal gig_combat_state_exit(old_state: Gig.CombatState)
signal gig_combat_state_enter(new_state: Gig.CombatState)
