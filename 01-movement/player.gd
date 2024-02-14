extends Sprite2D

@export var target_path = []

var is_moving = false
var target = Vector2.ZERO
var speed = 100

func _process(delta):
	if not is_moving and not target_path.is_empty():
		is_moving = true
		target = target_path.pop_front()
	
	var distance_to = global_position.distance_to(target)
	
	if is_moving and distance_to > 1:
		translate(global_position.direction_to(target) * delta * speed)
	else:
		is_moving = false
