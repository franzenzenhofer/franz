Franz.merge = (c, p...) ->
  #dlog('inmerge')
  [cb, picture] = fff(p, null)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  filter=(r,g,b,a,i) ->
    red = clamp((r*p_pxs[i])/255)
    green = clamp((g*p_pxs[i+1])/255)
    blue = clamp((b*p_pxs[i+2])/255)
    return [red,green,blue,a]
  Franz.rgba(c, cb, filter)

#just writs one image over the other
#using standard drawing methods
# omly makes sense if the second image has transparent pixels
# mode can by any of these https://developer.mozilla.org/en/Canvas_tutorial/Compositing
Franz.hardmerge = (c, p...) ->
  [cb, picture, alpha, mode] = fff(p, null, 'source-over', 1)
  [new_c, new_ctx, new_imgd, new_pxs]=Franz.getToolbox(copy(c))
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  new_ctx.globalCompositeOperation = mode;
  #todo set global alpha
  new_ctx.drawImage(p_c,0,0)
  nb(cb, new_c)


Franz.negmerge = (c, p...) ->
  #dlog('inmerge')
  [cb, picture] = fff(p, null)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  filter=(r,g,b,a,i) ->
    red = clamp((r/p_pxs[i])*255)
    green = clamp((g/p_pxs[i+1])*255)
    blue = clamp((b/p_pxs[i+2])*255)
    return [red,green,blue,a]
  Franz.rgba(c, cb, filter)

Franz.lightmerge = (c, p...) ->
  [cb, picture] = fff(p, null)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  filter = (r,g,b,a,i) ->
    r = (if r > p_pxs[i] then r else p_pxs[i])
    g = (if g > p_pxs[i+1] then g else p_pxs[i+1])
    b = (if b > p_pxs[i+2] then b else p_pxs[i+2])
    return [r,g,b,a]
  Franz.rgba(c, cb, filter)


Franz.darkmerge = (c, p...) ->
  [cb, picture] = fff(p, null)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  filter = (r,g,b,a,i) ->
    r = (if r < p_pxs[i] then r else p_pxs[i])
    g = (if g < p_pxs[i+1] then g else p_pxs[i+1])
    b = (if b < p_pxs[i+2] then b else p_pxs[i+2])
    return [r,g,b,a]
  Franz.rgba(c, cb, filter)



Franz.lightermerge = (c, p...) ->
  [cb, picture] = fff(p, null)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  filter = (r,g,b,a,i) ->
    lighter = (if getGrayscaleValue(r,g,b)>getGrayscaleValue( p_pxs[i], p_pxs[i+1], p_pxs[i+2]) then true else false)
    r = (if lighter then r else p_pxs[i])
    g = (if lighter then g else p_pxs[i+1])
    b = (if lighter then b else p_pxs[i+2])
    return [r,g,b,a]
  Franz.rgba(c, cb, filter)

Franz.darkermerge = (c, p...) ->
  [cb, picture] = fff(p, null)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  filter = (r,g,b,a,i) ->
    darker = (if getGrayscaleValue(r,g,b)<getGrayscaleValue( p_pxs[i], p_pxs[i+1], p_pxs[i+2]) then true else false)
    r = (if darker then r else p_pxs[i])
    g = (if darker then g else p_pxs[i+1])
    b = (if darker then b else p_pxs[i+2])
    return [r,g,b,a]
  Franz.rgba(c, cb, filter)

Franz.blend = (c, p...) ->
  [cb, picture, amount] = fff(p, null, 0.5)
  until picture then return false
  [p_c, p_ctx, p_imgd, p_pxs]=Franz.getToolbox(Franz.hardResize(picture, c.width, c.height))
  neg_amount = 1 - amount
  filter=(r,g,b,a,i) ->
    #[pr, pg, pb]=[p_pxs[i], p_pxs[i+1], p_pxs[i+2]]
    #alpha
    red = clamp((r*neg_amount)+(p_pxs[i]*amount))
    green = clamp((g*neg_amount)+(p_pxs[i+1]*amount))
    blue = clamp((b*neg_amount)+(p_pxs[i+2]*amount))
    return [red, green, blue, a]
  Franz.rgba(c, cb, filter)


Franz.viewfinder = (c, p...) ->
  [cb, src] = fffr(p, './img/viewfinder.png')
  cbr(cb, 'Franz.viewfinder')
  pic = new Image()
  pic.onload = () -> Franz.merge(c, pic, cb)
  pic.src = src
  return true

Franz.oldschool =  (c, p...) ->
  [cb, src] = fffr(p, './img/oldschool.png')
  cbr(cb, 'Franz.oldschool')
  pic = new Image()
  pic.onload = () -> Franz.lightermerge(c, pic, cb)
  pic.src = src
  return true