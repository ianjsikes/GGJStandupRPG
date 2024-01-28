extends VBoxContainer

var first = true


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.round_start.connect(_on_round_start)


func _on_round_start():
	if !first:
		$TickSFX.play()
	$Control/CurrentRound.text = "%s" % GameState.current_gig.round_counter
	$Control/TotalRounds.text = "%s" % GameState.current_gig.round_limit
	first = false
