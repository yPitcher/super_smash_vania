## HUD.gd — Fixed top health-bar overlay + end-of-match win screen.
extends CanvasLayer

# ── layout ────────────────────────────────────────────────────────────────────
const BAR_W  = 340.0
const BAR_H  = 26.0
const HUD_H  = 76.0
const PAD    = 14.0

# gold accent used throughout
const GOLD       = Color(0.62, 0.49, 0.10)
const GOLD_LIGHT = Color(0.95, 0.78, 0.22)

# ── state ─────────────────────────────────────────────────────────────────────
var _p1         = null
var _p2         = null
var _p1_fill    : Panel
var _p2_fill    : Panel
var _p1_hp_lbl  : Label
var _p2_hp_lbl  : Label
var _win_shown  = false

# ─────────────────────────────────────────────────────────────────────────────
func _ready():
	layer = 128
	_build_hud()
	yield(get_tree(), "idle_frame")
	_find_players()

func _find_players():
	for node in get_tree().get_nodes_in_group("Player"):
		if node.isPlayer2:
			_p2 = node
		else:
			_p1 = node

func _process(_delta):
	if _win_shown:
		return

	if _p1 and is_instance_valid(_p1):
		var r = clamp(float(_p1.hp) / float(_p1.max_hp), 0.0, 1.0)
		_p1_fill.rect_size.x = (BAR_W - 2.0) * r
		_p1_hp_lbl.text      = "%d  /  %d" % [_p1.hp, _p1.max_hp]
		_apply_fill_color(_p1_fill, r)

	if _p2 and is_instance_valid(_p2):
		var r = clamp(float(_p2.hp) / float(_p2.max_hp), 0.0, 1.0)
		var w = (BAR_W - 2.0) * r
		_p2_fill.rect_size.x     = w
		_p2_fill.rect_position.x = 1.0 + (BAR_W - 2.0) - w   # depletes right→left
		_p2_hp_lbl.text          = "%d  /  %d" % [_p2.hp, _p2.max_hp]
		_apply_fill_color(_p2_fill, r)

	# ── KO detection ─────────────────────────────────────────────────────────
	if _p1 and is_instance_valid(_p1) and _p1.hp <= 0:
		_show_win_screen("JULIUS  BELMONT")
	elif _p2 and is_instance_valid(_p2) and _p2.hp <= 0:
		_show_win_screen("SOMA  CRUZ")

func _apply_fill_color(fill: Panel, ratio: float):
	var s = fill.get_stylebox("panel") as StyleBoxFlat
	if not s:
		return
	if ratio > 0.5:
		s.bg_color = Color(0.08, 0.76, 0.20)
	elif ratio > 0.25:
		s.bg_color = Color(0.95, 0.68, 0.00)
	else:
		s.bg_color = Color(0.90, 0.08, 0.08)


# ═══════════════════════════════════════════════════════════════════════════════
#  Win screen
# ═══════════════════════════════════════════════════════════════════════════════

func _show_win_screen(winner_name: String):
	_win_shown = true

	var vp = get_viewport().size

	# ── dark vignette overlay ──────────────────────────────────────────────
	var overlay_style      = StyleBoxFlat.new()
	overlay_style.bg_color = Color(0.0, 0.0, 0.0, 0.72)

	var overlay            = Panel.new()
	overlay.anchor_right   = 1.0
	overlay.anchor_bottom  = 1.0
	overlay.add_stylebox_override("panel", overlay_style)
	overlay.mouse_filter   = Control.MOUSE_FILTER_IGNORE
	get_node("HUDRoot").add_child(overlay)

	# ── central card ──────────────────────────────────────────────────────
	var card_w = 480.0
	var card_h = 220.0

	var card_style                          = StyleBoxFlat.new()
	card_style.bg_color                     = Color(0.04, 0.03, 0.02, 0.97)
	card_style.border_color                 = GOLD
	card_style.set_border_width_all(3)
	card_style.corner_radius_top_left       = 10
	card_style.corner_radius_top_right      = 10
	card_style.corner_radius_bottom_left    = 10
	card_style.corner_radius_bottom_right   = 10
	card_style.shadow_color                 = Color(0.0, 0.0, 0.0, 0.90)
	card_style.shadow_size                  = 20

	var card              = Panel.new()
	card.rect_size        = Vector2(card_w, card_h)
	card.rect_position    = Vector2(vp.x * 0.5 - card_w * 0.5, vp.y * 0.5 - card_h * 0.5)
	card.add_stylebox_override("panel", card_style)
	get_node("HUDRoot").add_child(card)

	# Top gold accent bar inside card
	var accent = Panel.new()
	accent.rect_size     = Vector2(card_w, 4)
	accent.rect_position = Vector2(0, 0)
	accent.add_stylebox_override("panel", _solid(GOLD))
	card.add_child(accent)

	# "VITÓRIA!" label
	var title           = Label.new()
	title.text          = "VITÓRIA!"
	title.anchor_right  = 1.0
	title.rect_position = Vector2(0, 18)
	title.rect_size     = Vector2(card_w, 30)
	title.align         = Label.ALIGN_CENTER
	title.add_color_override("font_color", GOLD_LIGHT)
	card.add_child(title)

	# Separator line
	var sep = Panel.new()
	sep.rect_size     = Vector2(card_w - 60, 2)
	sep.rect_position = Vector2(30, 52)
	sep.add_stylebox_override("panel", _solid(Color(0.62, 0.49, 0.10, 0.55)))
	card.add_child(sep)

	# Winner name label
	var name_lbl           = Label.new()
	name_lbl.text          = winner_name
	name_lbl.anchor_right  = 1.0
	name_lbl.rect_position = Vector2(0, 62)
	name_lbl.rect_size     = Vector2(card_w, 40)
	name_lbl.align         = Label.ALIGN_CENTER
	name_lbl.add_color_override("font_color", Color(0.98, 0.95, 0.85))
	card.add_child(name_lbl)

	# "VENCEU" subtitle
	var sub           = Label.new()
	sub.text          = "VENCEU!"
	sub.anchor_right  = 1.0
	sub.rect_position = Vector2(0, 100)
	sub.rect_size     = Vector2(card_w, 20)
	sub.align         = Label.ALIGN_CENTER
	sub.add_color_override("font_color", Color(0.65, 0.62, 0.52))
	card.add_child(sub)

	# ── buttons ───────────────────────────────────────────────────────────
	var btn_rematch = _make_button("REVANCHE", GOLD, Color(0.04, 0.03, 0.02))
	btn_rematch.rect_size     = Vector2(160, 38)
	btn_rematch.rect_position = Vector2(card_w * 0.5 - 168, 152)
	btn_rematch.connect("pressed", self, "_on_rematch")
	card.add_child(btn_rematch)

	var btn_menu = _make_button("MENU", Color(0.40, 0.32, 0.10), Color(0.06, 0.05, 0.04))
	btn_menu.rect_size     = Vector2(160, 38)
	btn_menu.rect_position = Vector2(card_w * 0.5 + 8, 152)
	btn_menu.connect("pressed", self, "_on_menu")
	card.add_child(btn_menu)


func _on_rematch():
	get_tree().reload_current_scene()

func _on_menu():
	get_tree().change_scene("res://Scenes/Main menu.tscn")


# ═══════════════════════════════════════════════════════════════════════════════
#  HUD construction
# ═══════════════════════════════════════════════════════════════════════════════

func _build_hud():
	var vp_w = get_viewport().size.x

	var root           = Control.new()
	root.name          = "HUDRoot"
	root.anchor_right  = 1.0
	root.anchor_bottom = 1.0
	root.mouse_filter  = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	# Dark gothic background
	var bg_style                  = StyleBoxFlat.new()
	bg_style.bg_color             = Color(0.03, 0.03, 0.05, 0.94)
	bg_style.border_width_bottom  = 3
	bg_style.border_color         = GOLD
	bg_style.shadow_color         = Color(0.0, 0.0, 0.0, 0.70)
	bg_style.shadow_size          = 10

	var bg           = Panel.new()
	bg.anchor_right  = 1.0
	bg.margin_bottom = HUD_H
	bg.add_stylebox_override("panel", bg_style)
	root.add_child(bg)

	# Inner top highlight strip
	var top_hl           = Panel.new()
	top_hl.anchor_right  = 1.0
	top_hl.margin_bottom = 3
	top_hl.add_stylebox_override("panel", _solid(Color(0.62, 0.49, 0.10, 0.50)))
	root.add_child(top_hl)

	# P1 section
	var p1_sec           = _build_side(true)
	p1_sec.rect_position = Vector2(PAD, 0)
	root.add_child(p1_sec)
	_p1_fill   = p1_sec.get_node("BarBG/BarFill")
	_p1_hp_lbl = p1_sec.get_node("HPLabel")

	# VS badge
	var vs           = _build_vs()
	vs.rect_position = Vector2(vp_w * 0.5 - 30.0, 10.0)
	root.add_child(vs)

	# P2 section
	var p2_sec           = _build_side(false)
	p2_sec.rect_position = Vector2(vp_w - BAR_W - PAD * 2.0 - 4.0, 0)
	root.add_child(p2_sec)
	_p2_fill   = p2_sec.get_node("BarBG/BarFill")
	_p2_hp_lbl = p2_sec.get_node("HPLabel")


func _build_side(is_left: bool) -> Control:
	var sec           = Control.new()
	sec.rect_size     = Vector2(BAR_W + PAD, HUD_H)

	# Name
	var name_lbl           = Label.new()
	name_lbl.name          = "NameLabel"
	name_lbl.text          = "SOMA  CRUZ" if is_left else "JULIUS  BELMONT"
	name_lbl.rect_position = Vector2(0, 7)
	name_lbl.rect_size     = Vector2(BAR_W, 18)
	name_lbl.align         = Label.ALIGN_LEFT if is_left else Label.ALIGN_RIGHT
	name_lbl.add_color_override("font_color", Color(0.96, 0.88, 0.56))
	sec.add_child(name_lbl)

	# Bar background
	var bg_style                         = StyleBoxFlat.new()
	bg_style.bg_color                    = Color(0.05, 0.03, 0.03)
	bg_style.border_color                = Color(0.52, 0.41, 0.09)
	bg_style.set_border_width_all(2)
	bg_style.corner_radius_top_left      = 5
	bg_style.corner_radius_top_right     = 5
	bg_style.corner_radius_bottom_left   = 5
	bg_style.corner_radius_bottom_right  = 5
	bg_style.shadow_color                = Color(0.0, 0.0, 0.0, 0.55)
	bg_style.shadow_size                 = 4

	var bar_bg           = Panel.new()
	bar_bg.name          = "BarBG"
	bar_bg.rect_position = Vector2(0, 28)
	bar_bg.rect_size     = Vector2(BAR_W, BAR_H)
	bar_bg.add_stylebox_override("panel", bg_style)
	sec.add_child(bar_bg)

	# Fill
	var fill_style                         = StyleBoxFlat.new()
	fill_style.bg_color                    = Color(0.08, 0.76, 0.20)
	fill_style.corner_radius_top_left      = 4
	fill_style.corner_radius_top_right     = 4
	fill_style.corner_radius_bottom_left   = 4
	fill_style.corner_radius_bottom_right  = 4

	var bar_fill           = Panel.new()
	bar_fill.name          = "BarFill"
	bar_fill.rect_position = Vector2(1, 1)
	bar_fill.rect_size     = Vector2(BAR_W - 2, BAR_H - 2)
	bar_fill.add_stylebox_override("panel", fill_style)
	bar_bg.add_child(bar_fill)

	# Gloss highlight (top ~35% of fill)
	var gloss_style                       = StyleBoxFlat.new()
	gloss_style.bg_color                  = Color(1.0, 1.0, 1.0, 0.13)
	gloss_style.corner_radius_top_left    = 4
	gloss_style.corner_radius_top_right   = 4

	var gloss            = Panel.new()
	gloss.rect_position  = Vector2(0, 0)
	gloss.rect_size      = Vector2(BAR_W - 2, int((BAR_H - 2) * 0.36))
	gloss.mouse_filter   = Control.MOUSE_FILTER_IGNORE
	gloss.add_stylebox_override("panel", gloss_style)
	bar_fill.add_child(gloss)

	# HP number
	var hp_lbl           = Label.new()
	hp_lbl.name          = "HPLabel"
	hp_lbl.text          = "100  /  100"
	hp_lbl.rect_position = Vector2(0, 57)
	hp_lbl.rect_size     = Vector2(BAR_W, 14)
	hp_lbl.align         = Label.ALIGN_LEFT if is_left else Label.ALIGN_RIGHT
	hp_lbl.add_color_override("font_color", Color(0.55, 0.55, 0.58))
	sec.add_child(hp_lbl)

	return sec


func _build_vs() -> Panel:
	var style                         = StyleBoxFlat.new()
	style.bg_color                    = Color(0.06, 0.04, 0.02)
	style.border_color                = GOLD
	style.set_border_width_all(2)
	style.corner_radius_top_left      = 7
	style.corner_radius_top_right     = 7
	style.corner_radius_bottom_left   = 7
	style.corner_radius_bottom_right  = 7
	style.shadow_color                = Color(0.0, 0.0, 0.0, 0.80)
	style.shadow_size                 = 8

	var badge         = Panel.new()
	badge.rect_size   = Vector2(60, 56)
	badge.add_stylebox_override("panel", style)

	# Top decorative line
	var top_line           = Panel.new()
	top_line.rect_position = Vector2(10, 12)
	top_line.rect_size     = Vector2(40, 2)
	top_line.add_stylebox_override("panel", _solid(Color(0.62, 0.49, 0.10, 0.70)))
	badge.add_child(top_line)

	# VS label (fills the whole badge so it centers automatically)
	var lbl           = Label.new()
	lbl.text          = "VS"
	lbl.anchor_right  = 1.0
	lbl.anchor_bottom = 1.0
	lbl.align         = Label.ALIGN_CENTER
	lbl.valign        = Label.VALIGN_CENTER
	lbl.add_color_override("font_color", GOLD_LIGHT)
	badge.add_child(lbl)

	# Bottom decorative line
	var bot_line           = Panel.new()
	bot_line.rect_position = Vector2(10, 42)
	bot_line.rect_size     = Vector2(40, 2)
	bot_line.add_stylebox_override("panel", _solid(Color(0.62, 0.49, 0.10, 0.70)))
	badge.add_child(bot_line)

	return badge


func _make_button(txt: String, border_col: Color, bg_col: Color) -> Button:
	var normal = StyleBoxFlat.new()
	normal.bg_color                    = bg_col
	normal.border_color                = border_col
	normal.set_border_width_all(2)
	normal.corner_radius_top_left      = 5
	normal.corner_radius_top_right     = 5
	normal.corner_radius_bottom_left   = 5
	normal.corner_radius_bottom_right  = 5

	var hover         = normal.duplicate() as StyleBoxFlat
	hover.bg_color    = Color(border_col.r, border_col.g, border_col.b, 0.22)

	var pressed       = normal.duplicate() as StyleBoxFlat
	pressed.bg_color  = Color(border_col.r, border_col.g, border_col.b, 0.40)

	var btn = Button.new()
	btn.text = txt
	btn.add_stylebox_override("normal",  normal)
	btn.add_stylebox_override("hover",   hover)
	btn.add_stylebox_override("pressed", pressed)
	btn.add_stylebox_override("focus",   StyleBoxEmpty.new())
	btn.add_color_override("font_color",        GOLD_LIGHT)
	btn.add_color_override("font_color_hover",  Color(1, 1, 1))
	btn.add_color_override("font_color_pressed", GOLD_LIGHT)
	return btn


# ─────────────────────────────────────────────────────────────────────────────
func _solid(color: Color) -> StyleBoxFlat:
	var s      = StyleBoxFlat.new()
	s.bg_color = color
	return s
