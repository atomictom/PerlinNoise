// Generated by CoffeeScript 1.7.1
(function() {
  var KEY, Noise, canvas, ctx, draw_perlin_1d, draw_perlin_2d, init, print,
    __hasProp = {}.hasOwnProperty;

  this.print = print = console.log.bind(console);

  canvas = document.getElementById("canvas");

  ctx = canvas.getContext("2d");

  init = function(small) {
    if (small == null) {
      small = true;
    }
    if (small) {
      canvas.width = 800;
      canvas.height = 600;
    } else {
      canvas.width = window.innerWidth;
      canvas.height = window.innerHeight;
    }
    canvas.style.width = canvas.width;
    canvas.style.height = canvas.height;
    canvas.style.top = (window.innerHeight - canvas.height) / 2 + "px";
    return canvas.style.left = (window.innerWidth - canvas.width) / 2 + "px";
  };

  Noise = (function() {
    function Noise(given_options) {
      var default_options, key, value;
      default_options = {
        random: this.cached_rand,
        smoother: this.no_smooth,
        interpolator: this.cubic_interpolation,
        width: 800,
        height: 600
      };
      this.options = {};
      this.octaves = [];
      for (key in default_options) {
        if (!__hasProp.call(default_options, key)) continue;
        value = default_options[key];
        this.options[key] = value;
      }
      for (key in given_options) {
        if (!__hasProp.call(given_options, key)) continue;
        value = given_options[key];
        this.options[key] = value;
      }
    }

    Noise.prototype.gen_octave = function(frequency, amplitude, from, to) {
      var i, noises, random, skip_distance;
      if (from == null) {
        from = 0;
      }
      if (to == null) {
        to = this.options.width;
      }
      print(this.options);
      skip_distance = (to - from) / frequency;
      random = this.options.random;
      noises = (function() {
        var _i, _results;
        _results = [];
        for (i = _i = from; skip_distance > 0 ? _i <= to : _i >= to; i = _i += skip_distance) {
          _results.push([i, random(i) * amplitude]);
        }
        return _results;
      })();
      this.octaves.push(noises);
      return noises;
    };

    Noise.prototype.arbitrary_rand1 = function(x) {
      x = (x << 13) ^ x;
      return 1.0 - ((x * (x * x * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0;
    };

    Noise.prototype.arbitrary_rand2 = function(x) {
      x = (x * 9301 + 49297) % 233280;
      return x / 233280.0;
    };

    Noise.prototype.arbitrary_rand3 = function(x) {
      x = x * 1103515245 + 12345;
      return (x / 65536 % 32768) % 1.0;
    };

    Noise.prototype.arbitrary_rand4 = function(x) {
      var t, w, y, z;
      x = 123456789;
      y = 362436069;
      z = 521288629;
      w = 88675123;
      t = x ^ (x << 11);
      x = y;
      y = z;
      z = w;
      return (w = w ^ (w >> 19) ^ (t ^ (t >> 8))) % 1.0;
    };

    Noise.prototype.all_rand = function(x) {
      var fn, sources;
      sources = [this.arbitrary_rand1, this.arbitrary_rand2, this.arbitrary_rand3, this.arbitrary_rand4];
      return (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = sources.length; _i < _len; _i++) {
          fn = sources[_i];
          _results.push(fn(x));
        }
        return _results;
      })()).reduce(function(a, b) {
        return a + b;
      })) % 1.0;
    };

    Noise.prototype.cached_rand = function(x) {
      var _ref;
      if (this.rand_cache == null) {
        this.rand_cache = {};
      }
      return (_ref = this.rand_cache[x]) != null ? _ref : this.rand_cache[x] = Math.random();
    };

    Noise.prototype.no_smooth = function(x) {
      return x;
    };

    Noise.prototype.cubic_interpolation = function(from_index, to_index, x) {};

    Noise.prototype.cosine_interpolation = function(from_index, to_index, x) {};

    Noise.prototype.linear_interpolation = function(from_index, to_index, x) {};

    return Noise;

  })();

  draw_perlin_1d = function() {
    var noise, octave, point, _i, _len, _ref, _results;
    noise = new Noise({
      width: canvas.width
    });
    noise.gen_octave(16, canvas.height / 2, 10, canvas.width - 10);
    ctx.fillStyle = "black";
    ctx.fillRect(0, 0, canvas.width, canvas.height);
    ctx.fillStyle = "white";
    ctx.fillRect(0, (3 / 4) * canvas.height + 5, canvas.width, 3);
    _ref = noise.octaves;
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      octave = _ref[_i];
      _results.push((function() {
        var _j, _len1, _results1;
        _results1 = [];
        for (_j = 0, _len1 = octave.length; _j < _len1; _j++) {
          point = octave[_j];
          _results1.push(ctx.fillRect(point[0], (3 / 4) * canvas.height - point[1], 4, 4));
        }
        return _results1;
      })());
    }
    return _results;
  };

  draw_perlin_2d = function() {
    canvas.fillStyle = "black";
    return canvas.fillRect(0, 0, ctx.width, ctx.height);
  };

  init();

  draw_perlin_1d();

  KEY = {
    BACKSPACE: 8,
    TAB: 9,
    RETURN: 13,
    ESC: 27,
    SPACE: 32,
    PAGEUP: 33,
    PAGEDOWN: 34,
    END: 35,
    HOME: 36,
    LEFT: 37,
    UP: 38,
    RIGHT: 39,
    DOWN: 40,
    INSERT: 45,
    DELETE: 46,
    ZERO: 48,
    ONE: 49,
    TWO: 50,
    THREE: 51,
    FOUR: 52,
    FIVE: 53,
    SIX: 54,
    SEVEN: 55,
    EIGHT: 56,
    NINE: 57,
    A: 65,
    B: 66,
    C: 67,
    D: 68,
    E: 69,
    F: 70,
    G: 71,
    H: 72,
    I: 73,
    J: 74,
    K: 75,
    L: 76,
    M: 77,
    N: 78,
    O: 79,
    P: 80,
    Q: 81,
    R: 82,
    S: 83,
    T: 84,
    U: 85,
    V: 86,
    W: 87,
    X: 88,
    Y: 89,
    Z: 90,
    TILDA: 192
  };

}).call(this);
