// Generated by CoffeeScript 1.3.1
(function() {
  var __slice = [].slice;

  Franz.nothing = function() {
    var c, cb, filter, p;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    cb = fff(p)[0];
    filter = function(r, g, b, a) {
      return [r, g, b, a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.saturate = function() {
    var c, cb, filter, p, t, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 0.3), cb = _ref[0], t = _ref[1];
    filter = function(r, g, b, a) {
      var average;
      average = (r + g + b) / 3;
      return [clamp(average + t * (r - average)), clamp(average + t * (g - average)), clamp(average + t * (b - average)), a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.desaturate = function() {
    var c, cb, p, t, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 0.7), cb = _ref[0], t = _ref[1];
    return Franz.saturate(c, 1 - t, cb);
  };

  Franz.fill = function() {
    var bv, c, cb, gv, p, rv, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 0, 0, 0), cb = _ref[0], rv = _ref[1], gv = _ref[2], bv = _ref[3];
    return Franz.rgba(c, cb, function(r, g, b, a) {
      return [clamp(rv), clamp(gv), clamp(bv), a];
    });
  };

  Franz.posterize = function() {
    var c, cb, filter, levels, p, step, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 5), cb = _ref[0], levels = _ref[1];
    step = Math.floor(255 / levels);
    filter = function(r, g, b, a) {
      var b2, g2, r2;
      r2 = clamp(Math.floor(r / step) * step);
      g2 = clamp(Math.floor(g / step) * step);
      b2 = clamp(Math.floor(b / step) * step);
      return [r2, g2, b2, a];
    };
    return Franz.rgby(c, cb, filter);
  };

  Franz.grayScale = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      var average;
      average = (r + g + b) / 3;
      return [average, average, average, a];
    };
    return doRgbaFilter(c, cb, filter);
  };

  Franz.tint = function() {
    var c, cb, filter, max_b, max_g, max_r, min_b, min_g, min_r, p, tint_max, tint_min, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    tint_min = 85;
    tint_max = 170;
    _ref = fff(p, tint_min, tint_min, tint_min, tint_max, tint_max, tint_max), cb = _ref[0], min_r = _ref[1], min_g = _ref[2], min_b = _ref[3], max_r = _ref[4], max_b = _ref[5], max_g = _ref[6];
    if (min_r === max_r) {
      max_r = max_r + 1;
    }
    if (min_g === max_g) {
      max_g = max_g + 1;
    }
    if (min_b === max_b) {
      max_b = max_b + 1;
    }
    filter = function(r, g, b, a) {
      var b2, g2, r2;
      r2 = clamp((r - min_r) * (255 / (max_r - min_r)));
      g2 = clamp((g - min_r) * (255 / (max_g - min_g)));
      b2 = clamp((b - min_b) * (255 / (max_b - min_b)));
      return [r2, g2, b2, a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.sepia = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      var b2, g2, r2;
      r2 = (r * 0.393) + (g * 0.769) + (b * 0.189);
      g2 = (r * 0.349) + (g * 0.686) + (b * 0.168);
      b2 = (r * 0.272) + (g * 0.534) + (b * 0.131);
      return [clamp(r2), clamp(g2), clamp(b2), a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.blackWhite = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      var factor;
      factor = (r * 0.3) + (g * 0.59) + (b * 0.11);
      return [factor, factor, factor, a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.solarize = function(c, cb) {
    var filter;
    filter = function(r, g, b, a) {
      return [(r > 127 ? 255 - r : r), (g > 127 ? 255 - g : g), (b > 127 ? 255 - b : b), a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.screen = function() {
    var bb, c, cb, filter, gg, p, rr, strength, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 227, 12, 169, 0.2), cb = _ref[0], rr = _ref[1], gg = _ref[2], bb = _ref[3], strength = _ref[4];
    filter = function(r, g, b, a) {
      return [255 - ((255 - r) * (255 - rr * strength) / 255), 255 - ((255 - g) * (255 - gg * strength) / 255), 255 - ((255 - b) * (255 - bb * strength) / 255), a];
    };
    return Franz.rgba(c, cb, filter);
  };

  Franz.noise = function() {
    var amount, c, cb, dblHlp, i, k, new_c, new_ctx, new_imgd, new_pxs, noise, p, px, _i, _len, _ref, _ref1;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 20), cb = _ref[0], amount = _ref[1];
    _ref1 = getToolbox(copy(c)), new_c = _ref1[0], new_ctx = _ref1[1], new_imgd = _ref1[2], new_pxs = _ref1[3];
    for (i = _i = 0, _len = new_pxs.length; _i < _len; i = ++_i) {
      px = new_pxs[i];
      noise = Math.round(amount - Math.random() * amount / 2);
      dblHlp = 0;
      k = 0;
      while (k < 3) {
        new_pxs[i + k] = clamp(noise + new_pxs[i + k]);
        k = k + 1;
      }
    }
    new_ctx.putImageData(new_imgd, 0, 0);
    return nb(cb, new_c);
  };

  Franz.threshold = function() {
    var c, cb, filter, p, t, _ref;
    c = arguments[0], p = 2 <= arguments.length ? __slice.call(arguments, 1) : [];
    _ref = fff(p, 128), cb = _ref[0], t = _ref[1];
    filter = function(r, g, b, a) {
      if (r > t || g > t || b > t) {
        c = 255;
      } else {
        c = 0;
      }
      return [c, c, c, a];
    };
    return Franz.rgba(c, cb, filter);
  };

}).call(this);
