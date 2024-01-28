extends Control

@onready var arrow: TextureRect = $Arrow

@export var arrow_move_speed: float = 10.0

var meter_value: float = 50.0:
	set(value):
		meter_value = clampf(value, 0.0, 100.0)


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.meter_update.connect(_on_meter_update)


func _on_meter_update(new_meter_value: float, animated: bool):
	var old_value = meter_value
	meter_value = new_meter_value

	var new_angle = lerp_angle(-PI / 2.0 + 0.01, PI / 2.0 - 0.01, 1.0 - (meter_value / 100.0))
	print(
		(
			"METER UPDATE %.2f - %.2f - %.2f - %.2f"
			% [arrow.rotation, new_angle, meter_value / 100.0, new_meter_value]
		)
	)

	if animated:
		var distance = absf(old_value - meter_value)
		var t = create_tween()
		(
			t
			. tween_property(arrow, "rotation", new_angle, distance / arrow_move_speed)
			. set_ease(Tween.EASE_OUT)
			. set_trans(Tween.TRANS_SPRING)
		)
		await t.finished
	else:
		arrow.rotation = new_angle
