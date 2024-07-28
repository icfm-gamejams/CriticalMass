extends Node

@export var mob_scene: PackedScene
var score
var winner : Area2D

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
	winner = null
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	$Player/HUD.update_score(score)
	$Player/HUD.show_message("Get Ready")
	
	for i in range(0, 250):
		var mob = mob_scene.instantiate()
		
		#mob.position = $StartPosition.position + Vector2(200, 0)
		#mob.consumer_size = .5
		#mob.consumer_max_size = .5
		
		mob.position = Vector2(randf_range(0, 10432), 0).rotated(deg_to_rad(randf_range(0, 360)))
		
		while $StartPosition.position - Vector2(250, 250) < mob.position && mob.position < $StartPosition.position + Vector2(250, 250):
			mob.position = Vector2(randf_range(0, 10432), 0).rotated(deg_to_rad(randf_range(0, 360)))
			
		var direction = randf_range(0, 2 * PI)
		
		var velocity = Vector2(randf_range(50.0, 100.0), 0.0)
		mob.velocity = velocity.rotated(direction)
		
		$MobContainer.add_child(mob)
		mob.main_scene = self
		
		#if i == 1:
			#mob.consumer_max_size = 20

func _on_start_timer_timeout():
	$ScoreTimer.start()

func _on_score_timer_timeout():
	$Player/HUD.update_score($Player.consumer_max_size)

func _on_player_critical_mass_achieved(player):
	if winner == null:
		$Player.dead = true
		game_over()
		winner = player
		
func set_winner(mob):
	if winner == null:
		$Player.dead = true
		game_over()
		winner = mob
		
func _process(delta):
	if winner != null:
		if $Player != winner:
			var direction = (winner.position - $Player.position).normalized()
			$Player.velocity += direction * 1000 * delta
			$Player.position += $Player.velocity * delta
		
		if $MobContainer.get_child_count() == 0:
			game_over()
			
		for mob in $MobContainer.get_children():
			if mob != winner:
				var direction = (winner.position - mob.position).normalized()
				mob.velocity += direction * 1000 * delta
				
		for fragment in $FragmentContainer.get_children():
			fragment.acceleration = Vector2.ZERO
			var direction = (winner.position - fragment.position).normalized()
			fragment.velocity += direction * 1000 * delta


func _on_background_music_finished():
	$BackgroundMusic.play()
