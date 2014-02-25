# Thomas Manning
#
# Description:
# 	Something

# --------------- etc ---------------
@print = print = console.log.bind(console)

# --------------- Global Variables ---------------
canvas = document.getElementById("canvas")
ctx = canvas.getContext("2d")

# --------------- Functions ---------------

init = (small = true) ->
	if small
		canvas.width = 800
		canvas.height = 600
	else
		canvas.width = window.innerWidth
		canvas.height = window.innerHeight

	canvas.style.width = canvas.width
	canvas.style.height = canvas.height
	canvas.style.top = (window.innerHeight - canvas.height) / 2 + "px"
	canvas.style.left = (window.innerWidth - canvas.width) / 2 + "px"

class Noise1D
	constructor: (given_options) ->
		default_options =
			# random: "all"
			random: @cached_rand
			smoother: @no_smooth
			interpolator: @cubic_interpolation
			width: 800
			height: 600

		@options = {}
		@octaves = []
		for own key, value of default_options
			@options[key] = value
		for own key, value of given_options
			@options[key] = value

	gen_octave: (frequency, amplitude, from = 0, to = @options.width) ->
		print @options

		skip_distance = (to - from) / frequency
		random = @options.random
		noises = ([i, random(i) * amplitude] for i in [from..to] by skip_distance)
		# print "x: #{i[0]} y: #{i[1]}" for i in noises

		@octaves.push(noises)
		return noises

	# ---------- Random Functions ----------
	# An arbitrary random number generator
	arbitrary_rand1: (x) ->
		x = (x<<13) ^ x
		return (1.0 - ((x * (x * x * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0)

	arbitrary_rand2: (x) ->
		x = (x * 9301 + 49297) % 233280
		return x / 233280.0

	arbitrary_rand3: (x) ->
		x = x * 1103515245 + 12345
		return (x / 65536 % 32768) % 1.0

	arbitrary_rand4: (x) ->
		x = 123456789
		y = 362436069
		z = 521288629
		w = 88675123

		t = x ^ (x << 11)
		x = y; y = z; z = w
		return (w = w ^ (w >> 19) ^ (t ^ (t >> 8))) % 1.0

	all_rand: (x) ->
		sources = [
			@arbitrary_rand1
			@arbitrary_rand2
			@arbitrary_rand3
			@arbitrary_rand4
		]
		return ((fn x for fn in sources).reduce (a, b) -> a + b) % 1.0

	cached_rand: (x) ->
		@rand_cache ?= {}
		return @rand_cache[x] ? @rand_cache[x] = Math.random()

	# ---------- Smoothing Functions ----------
	# The identity function -- does not perform any smoothing
	no_smooth: (index) -> @noises[index]

	smooth: (index) -> (@noises[index - 1] ? 0) + @noises[index] + (@noises[index + 1] ? 0)

	# ---------- Interpolation Functions ----------
	linear_interpolation: (from_index, to_index, x) ->
		[a, b] = [@noises[from_index], @noises[to_index]]

		return a*(1 - x) + b*x

	cosine_interpolation: (from_index, to_index, x) ->
		[a, b] = [@noises[from_index], @noises[to_index]]

		freq = (1 - cos(x * Math.PI)) * .5
		return a*(1 - f) + b*f

	cubic_interpolation: (from_index, to_index, x) ->
		P = @noises[from_index-1] ? 0
		Q = @noises[from_index]
		R = @noises[to_index]
		S = @noises[to_index+1] ? 0

		return P*(x*x*x) + Q*(x*x) + R*x + S


# -------------------- Drawing Functions --------------------
draw_perlin_1d = () ->
	noise = new Noise({
		width: canvas.width
	})

	noise.gen_octave(16, canvas.height / 2, 10, canvas.width - 10)

	ctx.fillStyle = "black"
	ctx.fillRect(0, 0, canvas.width, canvas.height)

	ctx.fillStyle = "white"
	ctx.fillRect(0, (3/4) * canvas.height + 5, canvas.width, 3)
	for octave in noise.octaves
		for point in octave
			ctx.fillRect(point[0], (3/4) * canvas.height - point[1], 4, 4)

draw_perlin_2d = () ->
	canvas.fillStyle = "black"
	canvas.fillRect(0, 0, ctx.width, ctx.height)

init()
draw_perlin_1d()

# --------------- Other Stuff... ---------------
KEY =
	BACKSPACE: 8,
	TAB:       9,
	RETURN:   13,
	ESC:      27,
	SPACE:    32,
	PAGEUP:   33,
	PAGEDOWN: 34,
	END:      35,
	HOME:     36,
	LEFT:     37,
	UP:       38,
	RIGHT:    39,
	DOWN:     40,
	INSERT:   45,
	DELETE:   46,
	ZERO:     48, ONE: 49, TWO: 50, THREE: 51, FOUR: 52, FIVE: 53, SIX: 54, SEVEN: 55, EIGHT: 56, NINE: 57,
	A:        65, B: 66, C: 67, D: 68, E: 69, F: 70, G: 71, H: 72, I: 73, J: 74, K: 75, L: 76, M: 77,
	N: 	  78, O: 79, P: 80, Q: 81, R: 82, S: 83, T: 84, U: 85, V: 86, W: 87, X: 88, Y: 89, Z: 90,
	TILDA:    192

# KEY =
# 	8: "backspace"
# 	9: "tab"
# 	13: "return"
# 	27: "esc"
# 	32: "space"
# 	33: "pageup"
# 	34: "pagedown"
# 	35: "end"
# 	36: "home"
# 	37: "left"
# 	38: "up"
# 	39: "right"
# 	40: "down"
# 	45: "insert"
# 	46: "delete"
# 	48: "zero"
# 	49: "one"
# 	50: "two"
# 	51: "three"
# 	52: "four"
# 	53: "five"
# 	54: "six"
# 	55: "seven"
# 	56: "eight"
# 	57: "nine"
# 	65: "a"
# 	66: "b"
# 	67: "c"
# 	68: "d"
# 	69: "e"
# 	70: "f"
# 	71: "g"
# 	72: "h"
# 	73: "i"
# 	74: "j"
# 	75: "k"
# 	76: "l"
# 	77: "m"
# 	78: "n"
# 	79: "o"
# 	80: "p"
# 	81: "q"
# 	82: "r"
# 	83: "s"
# 	84: "t"
# 	85: "u"
# 	86: "v"
# 	87: "w"
# 	88: "x"
# 	89: "y"
# 	90: "z"
# 	192: "tilda"

# --------------- Old Code Bits ---------------

# # --------------- Flip the buffers ---------------
# # Flip which buffer is visible
# buffers[1 - current_buffer].style.visibility = 'none'
# buffers[current_buffer].style.visibility = 'visible'
# # Toggle the current buffer
# current_buffer = 1 - current_buffer
# # Set the new current_buffer to be the one we work with (it's the hidden one
# canvas = buffers[current_buffer]
# ctx = canvas.getContext("2d")

# canvas1 = document.getElementById("canvas1")
# canvas2 = document.getElementById("canvas2")
# buffers = [canvas1, canvas2]
# current_buffer = 0

# updateScreen = () ->
# 	window.requestAnimationFrame(updateScreen)
#
# gameloop = (previous_time) ->
# 	if not running
# 		return
#
# 	current_time = Date.now()
# 	frame_time = current_time - previous_time
#
# 	if frame_time > max_frame_time * update_interval
# 		frame_time = max_frame_time
#
# 	time_accumulator += frame_time
#
# 	while time_accumulator >= update_interval
# 		updateLogic(total_time, update_interval)
# 		total_time += update_interval
# 		time_accumulator -= update_interval
#
# 	setTimeout((-> gameloop(current_time)), render_interval)
#
# gameloop(0)
# updateScreen()

# fps = 60
# ups = 60
# update_interval = 1000 / ups
# render_interval = 1000 / fps
# max_frame_time = (ups / 4)
# time_accumulator = 0
# total_time = 0
# running = true
# paused = false
