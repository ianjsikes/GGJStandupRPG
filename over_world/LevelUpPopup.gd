extends CanvasLayer

var done = false


func _ready():
	$Background.modulate.a = 0.0
	$Background.hide()
	$CenterContainer.modulate.a = 0.0
	$CenterContainer.hide()

	Events.level_up.connect(_on_level_up)


func _on_level_up():
	$Background.show()
	$CenterContainer.show()
	var tween = create_tween()
	var time = 0.8
	tween.tween_property($Background, "modulate:a", 0.5, time)
	tween.parallel().tween_property($CenterContainer, "modulate:a", 1.0, time)
	await tween.finished


func fade_out():
	var tween = create_tween()
	var time = 0.8
	tween.tween_property($Background, "modulate:a", 0.5, time)
	tween.parallel().tween_property($CenterContainer, "modulate:a", 1.0, time)
	await tween.finished
	$Background.hide()
	$CenterContainer.hide()


func _on_timing_pressed():
	if !done:
		GameState.accuracy_stat += 1
		done = true
		fade_out()


func _on_punch_pressed():
	if !done:
		GameState.attack_stat += 1
		done = true
		fade_out()


func _on_confidence_pressed():
	if !done:
		GameState.defense_stat += 1
		done = true
		fade_out()
