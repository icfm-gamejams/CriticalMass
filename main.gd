extends Node

@export var mob_scene: PackedScene
var score: float
var winner: Area2D

func _ready():
	$Player.position = $StartPosition.position
	$Player.main_scene = self

func game_over():
	$ScoreTimer.stop()
	$Player/HUD.show_game_over()
	
func new_game():
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("fragments", "queue_free")
	score = 0
	if winner != null:
		winner.remove_from_group("critical_mass")
	winner = null
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$Player/HUD.update_score(score)
	$Player/HUD.show_message("Get Ready")
	
	for i in range(0, 250):
		var mob = mob_scene.instantiate()		
		mob.position = Vector2(randf_range(0, 10432), 0).rotated(deg_to_rad(randf_range(0, 360)))
		
		while $StartPosition.position - Vector2(250, 250) < mob.position && mob.position < $StartPosition.position + Vector2(250, 250):
			mob.position = Vector2(randf_range(0, 10432), 0).rotated(deg_to_rad(randf_range(0, 360)))
			
		var direction = randf_range(0, 2 * PI)
		
		var velocity = Vector2(randf_range(50.0, 100.0), 0.0)
		mob.velocity = velocity.rotated(direction)
		
		mob.connect("critical_mass_achieved", _on_critical_mass_achieved)
		
		$MobContainer.add_child(mob)
		mob.main_scene = self
		

func _on_start_timer_timeout():
	$ScoreTimer.start()

func _on_score_timer_timeout():
	$Player/HUD.update_score($Player.consumer_max_size)

func _process(delta):
	if winner != null:
		for node in get_tree().get_nodes_in_group("consumers"):
			if node != winner:
				var direction = (winner.position - node.position).normalized()
				node.velocity += direction * 1000 * delta
	

func _on_background_music_finished():
	$BackgroundMusic.play()

func _on_critical_mass_achieved(consumer):
	if winner == null:
		winner = consumer
		winner.add_to_group("critical_mass")
		game_over()
		$Player.input_available = false
		winner.input_available = false
		winner.motion_available = false
