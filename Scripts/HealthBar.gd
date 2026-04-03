extends Node2D

const BAR_WIDTH  = 80.0
const BAR_HEIGHT = 8.0

func _draw():
	var character = get_parent()
	if not character or not "hp" in character:
		return
	var ratio = clamp(float(character.hp) / float(character.max_hp), 0.0, 1.0)

	# Border
	draw_rect(Rect2(-BAR_WIDTH / 2 - 1, -1, BAR_WIDTH + 2, BAR_HEIGHT + 2), Color(0, 0, 0))
	# Background
	draw_rect(Rect2(-BAR_WIDTH / 2, 0, BAR_WIDTH, BAR_HEIGHT), Color(0.25, 0.0, 0.0))
	# Fill
	if ratio > 0:
		var fill_color
		if ratio > 0.5:
			fill_color = Color(0.1, 0.85, 0.1)
		elif ratio > 0.25:
			fill_color = Color(1.0, 0.75, 0.0)
		else:
			fill_color = Color(0.9, 0.05, 0.05)
		draw_rect(Rect2(-BAR_WIDTH / 2, 0, BAR_WIDTH * ratio, BAR_HEIGHT), fill_color)

func _process(_delta):
	update()
