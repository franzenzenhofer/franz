Franz.nothing = (c, p...) ->
  [cb] = fff(p)
  filter = (r,g,b,a) -> [r,g,b,a]
  Franz.rgba(c,cb,filter)

Franz.saturate =  (c, p...) ->
  [cb, t]=fff(p, 0.3)
  filter = (r,g,b,a) ->
    average = (r+g+b)/3
    [
      clamp(average + t * (r - average))
      clamp(average + t * (g - average))
      clamp(average + t * (b - average))
      a
    ]
  Franz.rgba(c, cb, filter) #important, callback must be first function

Franz.desaturate = (c, p...) ->
  [cb, t]=fff(p, 0.7)
  Franz.saturate(c,1-t,cb)

#fill a canvas with a given color
Franz.fill = (c, p...) ->
  [cb, rv, gv, bv] = fff(p,0,0,0)
  Franz.rgba(c, cb, (r,g,b,a)->[clamp(rv), clamp(gv), clamp(bv), a])

#native posterize implementation
Franz.posterize = (c, p...) ->
  [cb, levels]=fff(p,5)
  step = Math.floor(255 / levels)
  filter = (r,g,b,a) ->
    r2 = clamp(Math.floor(r / step) * step)
    g2 = clamp(Math.floor(g / step) * step)
    b2 = clamp(Math.floor(b / step) * step)
    return [r2, g2, b2, a]
  Franz.rgby(c,cb,filter)

Franz.grayScale = (c, cb) ->
  filter = (r,g,b,a) ->
    average = (r+g+b)/3
    return [average, average, average, a]
  doRgbaFilter(c, cb, filter)

Franz.tint = (c, p...) ->
  tint_min = 85
  tint_max = 170
  [cb, min_r, min_g, min_b, max_r, max_b, max_g]=fff(p,tint_min,tint_min,tint_min,tint_max,tint_max,tint_max)
  if min_r is max_r then max_r = max_r+1
  if min_g is max_g then max_g = max_g+1
  if min_b is max_b then max_b = max_b+1
  filter = (r,g,b,a) ->
    r2 = clamp((r - min_r) * ((255 / (max_r - min_r))))
    g2 = clamp((g - min_r) * ((255 / (max_g - min_g))))
    b2 = clamp((b - min_b) * ((255 / (max_b - min_b))))
    return [r2,g2,b2,a]
  Franz.rgba(c, cb, filter)

Franz.sepia = (c, cb) ->
  filter = (r,g,b,a) ->
    r2 = (r * 0.393) + (g * 0.769) + (b * 0.189)
    g2 = (r * 0.349) + (g * 0.686) + (b * 0.168)
    b2 = (r * 0.272) + (g * 0.534) + (b * 0.131)
    return [clamp(r2), clamp(g2), clamp(b2), a]
  Franz.rgba(c, cb, filter)

Franz.blackWhite = (c, cb) ->
  filter = (r,g,b,a) -> factor = (r * 0.3) + (g * 0.59) + (b * 0.11); return [factor, factor, factor, a]
  Franz.rgba(c, cb, filter)

Franz.solarize = (c, cb) ->
  filter = (r,g,b,a) -> [
    (if r > 127 then 255-r else r)
    (if g > 127 then 255-g else g)
    (if b > 127 then 255-b else b)
    a
    ]
  Franz.rgba(c,cb,filter)

Franz.screen =  (c, p...) ->
  [cb, rr, gg, bb, strength] = fff(p, 227, 12, 169, 0.2)
  filter = (r,g,b,a) ->
    [
      (255 - ((255 - r) * (255 - rr * strength) / 255))
      (255 - ((255 - g) * (255 - gg * strength) / 255))
      (255 - ((255 - b) * (255 - bb * strength) / 255))
      a
    ]
  Franz.rgba(c,cb,filter)

Franz.noise = (c, p...) ->
  [cb, amount]=fff(p,20)
  [new_c, new_ctx, new_imgd, new_pxs]=getToolbox(copy(c))
  for px, i in new_pxs
    noise = Math.round(amount - Math.random() * amount/2)
    dblHlp = 0
    k=0
    while k<3
      new_pxs[i+k] = clamp(noise + new_pxs[i+k])
      k=k+1
  new_ctx.putImageData(new_imgd,0,0)
  nb(cb, new_c)

#everything above the threshold will be black, everything below will be white
Franz.threshold = (c, p...) ->
  [cb, t]=fff(p, 128)
  filter = (r,g,b,a) ->
    if r > t or g > t or b > t then c = 255 else c = 0
    return [c,c,c,a]
  Franz.rgba(c,cb,filter)