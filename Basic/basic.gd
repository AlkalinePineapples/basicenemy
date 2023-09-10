extends CharacterBody2D

var speed = 300
var acceleration = 4800
var friction = 4800
@export var navagent: NavigationAgent2D
@onready var targetnode = get_parent().get_node("TargetNode")
enum {IDLE, MOVE, SHOOT}
var state = MOVE
var target : CharacterBody2D

func _ready():
	print(str(targetnode))
func _physics_process(delta):
	match state:
		IDLE:
			speed = 300
			$Range/CollisionShape2D.shape.radius = 170
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		MOVE:
			var direction = to_local(navagent.get_next_path_position()).normalized()
			velocity = velocity.move_toward(direction * speed, acceleration * delta)
			$head.look_at(targetnode.global_position)
			if global_position.distance_to(targetnode.global_position) <= speed * delta * 5:
				get_parent().start_timer()
				state = IDLE
		SHOOT:
			get_parent().stop_timer()
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			$head.look_at(target.global_position)
			targetnode.global_position = target.global_position
	move_and_slide()
	
	


func _on_hitbox_area_entered(area):
	area.get_parent().queue_free()
	get_parent().queue_free()

func makepath():
	navagent.target_position = targetnode.global_position

func _on_update_nav_timeout():
	makepath()

func _on_range_body_entered(body):
	target = body
	state = SHOOT

func _on_range_body_exited(body):
	speed = 450
	$Range/CollisionShape2D.shape.radius = 250
	state = MOVE
	target = null
