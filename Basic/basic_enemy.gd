extends Node2D
var wander_range = 200
enum {IDLE, MOVE, SHOOT}
var isinwall = false
@onready var originalpos = $TargetNode.global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func start_timer():
	if $PatrolTimer.is_stopped():
		$PatrolTimer.start()

func stop_timer():
	$PatrolTimer.stop()

func _on_patrol_timer_timeout():
	var originalpos = $TargetNode.global_position
	if $basic.state != SHOOT:
		setnewtarget()
func setnewtarget():
	#sets target position
	var target_vector = Vector2(randf_range(-wander_range, wander_range), randf_range(-wander_range, wander_range))
	$TargetNode.global_position = originalpos + target_vector
	await get_tree().create_timer(0.05).timeout
	if isinwall == true:
		print("redoing")
		setnewtarget()
	else:
		print("success")
		$basic.state = MOVE

func _on_wall_detect_body_entered(body):
	isinwall = true
	print("in a wall")



func _on_wall_detect_body_exited(body):
	isinwall = false
	print("not in a wall")
