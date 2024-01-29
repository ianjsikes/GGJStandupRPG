extends Control

var set_jokes: Array[Joke] = []
var pool_jokes: Array[Joke] = []


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.choose_joke.connect(_on_choose_joke)

	for joke_scene in GameState.joke_set:
		var joke = joke_scene.instantiate()
		$AllJokes.add_child(joke)
		set_jokes.append(joke)
	$SetList.initialize_moves(set_jokes)
	$SetLabel.text = "Your Set (%s/%s)" % [GameState.joke_set.size(), GameState.max_set_size]

	for joke_scene in GameState.joke_pool:
		var joke = joke_scene.instantiate()
		$AllJokes.add_child(joke)
		pool_jokes.append(joke)
	$PoolList.initialize_moves(pool_jokes)


func _on_choose_joke(joke_name: String):
	print("ON CHOOOSE", joke_name, set_jokes)
	for i in set_jokes.size():
		var joke = set_jokes[i]
		if joke.joke_name == joke_name:
			print("Found joke??")
			var scene = remove_from_array(joke, GameState.joke_set)
			GameState.joke_pool.append(scene)
			set_jokes.remove_at(i)
			pool_jokes.append(joke)
			$SetList.remove_joke_from_list(joke_name)
			$PoolList.add_joke_to_list(joke)
			update_labels()
			return

	if GameState.joke_set.size() < GameState.max_set_size:
		for i in pool_jokes.size():
			var joke = pool_jokes[i]
			if joke.joke_name == joke_name:
				print("Found joke??")
				var scene = remove_from_array(joke, GameState.joke_pool)
				GameState.joke_set.append(scene)
				pool_jokes.remove_at(i)
				set_jokes.append(joke)
				$PoolList.remove_joke_from_list(joke_name)
				$SetList.add_joke_to_list(joke)
				update_labels()
				return


func remove_from_array(joke: Joke, arr: Array[PackedScene]):
	for i in arr.size():
		var joke_scene = arr[i]
		if joke_scene.resource_path == joke.scene_file_path:
			arr.remove_at(i)
			return joke_scene


func update_labels():
	$SetLabel.text = "Your Set (%s/%s)" % [GameState.joke_set.size(), GameState.max_set_size]


func _on_back_button_pressed():
	# TODO: Go to map scene
	SceneManager.change_scene("res://over_world/OverWorld.tscn", {"pattern": "curtains"})
