extends Control
class_name BuffIndicator

var buff: Buff
var hovered: bool = false:
	set(value):
		hovered = value
		if value:
			$TooltipPanel.show()
		else:
			$TooltipPanel.hide()


func _ready():
	Events.buff_update.connect(_on_buff_update)
	$TooltipPanel.hide()


func _process(delta):
	if hovered:
		$TooltipPanel.position = (
			get_local_mouse_position() - Vector2($TooltipPanel.size.x, 0.0) + Vector2(-10.0, 10.0)
		)


func setup(_buff: Buff):
	buff = _buff
	update_buff_ui()


func _on_buff_update(_buff: Buff):
	if _buff == buff:
		if buff.counter == 0:
			queue_free()
		else:
			update_buff_ui()


func update_buff_ui():
	$TextureRect.texture = buff.buff_icon
	$TooltipPanel/TooltipLabel.text = buff.buff_tooltip

	if buff.counter > 1 or buff.timed:
		$Counter.show()
		$Counter.text = "%s" % buff.counter
	else:
		$Counter.hide()

	# self.text = message


func _on_texture_rect_mouse_exited():
	hovered = false


func _on_texture_rect_mouse_entered():
	hovered = true
