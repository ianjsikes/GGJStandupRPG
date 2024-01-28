extends Effect
class_name LaughEffect

@export var laughs: float

@export var clears_buff: String
@export var scales_buff: String
@export var max_buff_stacks: int = 1


func apply(type: Types.JokeType):
	GameState.gig_player._reduce_buffs()

	if clears_buff:
		if GameState.gig_player.current_mods.has(clears_buff):
			var buff_count = GameState.gig_player.current_mods[clears_buff]
			if max_buff_stacks > -1:
				buff_count = maxi(buff_count, max_buff_stacks)
				Events.clear_buff.emit(clears_buff, buff_count)
			else:
				Events.clear_buff.emit(clears_buff, -1)
			Events.apply_laughs.emit(laughs * buff_count, type)
	elif scales_buff:
		if GameState.gig_player.current_mods.has(scales_buff):
			var buff_count = GameState.gig_player.current_mods[scales_buff]
			Events.apply_laughs.emit(laughs * buff_count, type)
	else:
		Events.apply_laughs.emit(laughs, type)
