extends CanvasLayer


func _ready():
	$Background.modulate.a = 0.0
	$Background.hide()
	$CenterContainer.modulate.a = 0.0
	$CenterContainer.hide()

	Events.gig_combat_state_enter.connect(_on_enter_combat_state)
	Events.gig_combat_state_exit.connect(_on_exit_combat_state)


func _on_enter_combat_state(state: Gig.CombatState):
	if state == Gig.CombatState.LOSE:
		$Background.show()
		$CenterContainer.show()
		var tween = create_tween()
		var time = 0.8
		tween.tween_property($Background, "modulate:a", 0.5, time)
		tween.parallel().tween_property($CenterContainer, "modulate:a", 1.0, time)
		await tween.finished


func _on_exit_combat_state(_state: Gig.CombatState):
	pass


func _on_leave_button_pressed():
	SceneManager.change_scene("res://start_menu/StartMenu.tscn", {"pattern": "curtains"})
