extends Node

signal apply_laughs(laughs: float, type: Types.JokeType)
signal meter_update(meter: float, animated: bool)

signal round_end
signal round_start
signal choose_joke(joke_name: String)
signal gig_begin

signal show_tutorial(tutorial_name: String)
signal hide_tutorial(tutorial_name: String)
signal bring_joke_card_to_front(index: int)

signal crowd_supereffective
signal crowd_ineffective
signal crowd_normal_effective
signal crowd_lose_laughs

signal player_end_turn
signal crowd_end_turn
signal buff_new(buff: Buff)
signal buff_added(buff: Buff)
signal buff_update(buff: Buff)
signal joke_land
signal joke_miss
signal set_debug_message(message: String)
signal gig_combat_state_exit(old_state: Gig.CombatState)
signal gig_combat_state_enter(new_state: Gig.CombatState)
