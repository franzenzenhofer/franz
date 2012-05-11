#PUBLIC HELPER

#private image data optimized clamp
Franz.clamp = clamp = (v, min=0, max=255) ->Math.min(max, Math.max(min, v))

#all PUBLIC HELPER are availabe via a Franz method and via an internal function name
#[context, imagedata, imagedata.data] = getToolbox(c)
Franz.getToolbox = getToolbox = (c,cb) ->
  #[c, ctx = c.getContext('2d'), img_data = ctx.getImageData(0,0,c.width,c.height), img_data.data]
  nb(cb, [c, ctx = c.getContext('2d'), img_data = ctx.getImageData(0,0,c.width,c.height), img_data.data])

#takes either width or height as parameters - or - an object with a width and height - and returns a canvas
Franz.make = make = (p...) ->
  [cb, width, height, origin]=fff(p,800,600)
  if width.width and width.height
    element = width
    width = element.width
    height = element.height
    origin = (element?.getAttribute?('id') or element?.getAttribute?('origin'))


  c=document.createElement('canvas')
  c.width=width
  c.height=height
  c.setAttribute('origin', origin) if origin
  nb(cb,c)

Franz.newToolbox = newToolbox = (p...) ->
  #dlog('in new toolbox 2')
  [cb, width, height, origin] = fff(p)
  #dlog('after ff in new toolbox 2')
  Franz.getToolbox(make(width, height, origin),cb)

Franz.copy = copy = (c, cb) ->
  #dlog(c)
  #dlog('in copy')
  [new_c,new_ctx] = Franz.newToolbox(c)
  #dlog('after new toolbox')
  new_ctx.drawImage(c,0,0,c.width,c.height)
  nb(cb,new_c)

Franz.byImage = byImage =  (img, cb) ->
  #dlog(img)
  if img.width and img.height
    ##dlog('imgwidth and imgheight are given in byImage')
    copy(img, cb)
  else
    ##dlog('width and height are not given')
    cbr(cb, 'Franz.byImage (only if the image is not "loaded")')
    if isFunction(cb)
      img.onload = ()->Franz.byImage(img,cb)
    return true

Franz.byArray = byArray = (a,w,h,cb) ->
  [c, ctx, imgd, pxs] = newToolbox(w,h)
  i = 0
  while i < pxs.length
    pxs[i] = a[i]
    i=i+1
  ctx.putImageData(imgd,0,0)
  nb(cb,c)

Franz.toImage = toImage = (c, p...) ->
  [cb, mime]=fff(p, 'image/png')
  img = new Image()
  img.src=c.toDataURL(mime, "")
  nb(cb,img)

Franz.toArray = toArray = (c, cb) ->
  a = []
  [c, ctx, imgd, px] = getToolbox(c)
  if Uint8Array then a = new Uint8Array(new ArrayBuffer(px.length))
  i = 0
  while i < px.length
    a[i]=px[i]
    i=i+1
  return a

#RGBAFILTER
Franz.rgba = rgba = (c, p...) ->
  [cb, filter, extended] = fff(p, null, false)
  if not isFunction(filter)
    #dlog('filter not a function')
    return false
  [c, ctx, imgd, pxs] = getToolbox(c)
  [w,h]=[c.width,c.height]
  u8 = new Uint8Array(new ArrayBuffer(pxs.length))
  y = 0
  while y < h
    x = 0
    yw = y*w
    #yw4= yw4
    while x < w
      #i = (y*w + x) * 4
      i = (yw+x)*4
      #i= yw4+x*4
      r = i; g = i+1; b = i+2;a = i+3
      if not extended
        [u8[r],u8[g],u8[b],u8[a]] = filter(pxs[r],pxs[g],pxs[b],pxs[a], i)
      else
        [u8[r],u8[g],u8[b],u8[a]] = filter(pxs[r],pxs[g],pxs[b],pxs[a], i, c)
      x=x+1
    y=y+1
  new_c = Franz.byArray(u8, w,h)
  nb(cb, new_c)

Franz.getGrayscaleValue = getGrayscaleValue = (r,g,b) -> r*0.3+g*0.59+b*0.11