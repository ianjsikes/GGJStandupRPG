extends Container

@export var buff_indicator_scene: PackedScene


func _ready():
	print("BuffsListContainer _ready")
	Events.buff_added.connect(_buff_added)


func _buff_added(buff: Buff):
	print("BuffsListContainer _buff_added")
	var buff_indicator: BuffIndicator = buff.buff_indicator_scene.instantiate()
	add_child(buff_indicator)
	buff_indicator.setup(buff)
