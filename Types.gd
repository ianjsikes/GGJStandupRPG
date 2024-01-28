extends Node

enum JokeType {
	VANILLA,
	OBSERVATION,
	STORYTELLING,
	DIRTY,
}


func joke_type_to_string(type: JokeType) -> String:
	match type:
		JokeType.VANILLA:
			return "Vanilla"
		JokeType.OBSERVATION:
			return "Observation"
		JokeType.STORYTELLING:
			return "Storytelling"
		JokeType.DIRTY:
			return "Dirty"
		_:
			return "Vanilla"
