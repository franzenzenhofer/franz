// Generated by CoffeeScript 1.3.1
(function() {

  Franz.rotateRight = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = newToolbox(c), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.rotate(90 * Math.PI / 180);
    new_ctx.drawImage(c, 0, c.height * -1);
    return nb(cb, c);
  };

  Franz.rotateLeft = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = newToolbox(c), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.rotate(-90 * Math.PI / 180);
    new_ctx.drawImage(c, c.width * -1, 0);
    return nb(cb, c);
  };

  Franz.flip = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = newToolbox(c), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.rotate(Math.PI);
    new_ctx.drawImage(c, c.width * -1, c.height * -1);
    return nb(cb, c);
  };

  Franz.mirror = function(c, cb) {
    var new_c, new_ctx, _ref;
    _ref = newToolbox(c), new_c = _ref[0], new_ctx = _ref[1];
    new_ctx.translate(c2.width / 2, 0);
    new_ctx.scale(-1, 1);
    new_ctx.drawImage(c, (c2.width / 2) * -1, 0);
    return nb(cb, c);
  };

}).call(this);
