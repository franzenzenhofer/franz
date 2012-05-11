
Franz.hardResize = hardResize = (c, w, h, cb) ->
  [new_c, new_ctx]=Franz.newToolbox(w, h)
  new_ctx.drawImage(c, 0, 0, w, h)
  nb(cb,new_c)

#resize
Franz.resize = resize = (c, p...) ->
  max =
    width: null
    height: null

  min =
    width: null
    height: null

  [cb, max['width'], max['height'], min['width'], min['height'], first] = fff(p,800, null, null, null, null, null)
  second = null
  r =
    width: null
    height: null

  if first is 'width'
    second = 'height'
  else if first is 'height'
    second = 'width'
  else
    if c.height > c.width
      first='height'
      second='width'
      #dlog('hochformat')
    else
      #dlog('height'+c.height)
      #dlog('width'+c.width)
      first='width'
      second='height'
      #dlog('querformat')
  console.log('hallo')
  #dlog('first: '+first )
  #dlog('second: '+second )
  #dlog(c[first])
  #return c
  #scale down
  #w=img.height*(default_width / img.width)
  if max[first] and (c[first] > max[first] or c[second] > max[second])
    #dlog('a')
    r[second]=c[second]*max[first]/c[first]
    r[first]=max[first]
    if r[second]>max[second]
      #dlog('b')
      r[first]=c[first]*max[second]/c[second]
      r[second]=max[second]

  #scale down
  #if c[first] > max[first]
  #  #dlog(first+'>'+max[first])
  #  r[first]=max[first]
  #  r[second]=c[second]*max[first]/c[first]
  #  if r[second] > max[second]
  #
  # #scale up
  else if min[first] and (c[first] < min[first] or c[second] > min[second])
    #dlog('c')
    r[first]=c[first] * min[second] / c[second]
    r[second]=min[second]
    if r[first]<min[first]
      #dlog('d')
      r[second]=c[second]*min[first]/c[first]
      r[first]=min[first]
  else
    #dlog('e')
    r[first]=c[first]
    r[second]=c[second]
    #dlog('f')

  #cd.context.drawImage(img, 0,0, newwidth, newheight)
  ##dlog('inresizedebugoutput')
  ##dlog((c?.getAttribute('id') or c?.getAttribute('source')))
  [new_c, new_ctx]=newToolbox(r.width, r.height, (c?.getAttribute('id') or c?.getAttribute('origin')))
  new_ctx.drawImage(c, 0,0, r.width, r.height)
  #dlog('g')
  #dlog(new_c)
  #dlog(cb)
  return nb(cb, new_c)

Franz.scale = scale = (c, p...) ->
  [cb, x]=fff(p, 1)
  #dlog('scale it by '+x)
  new_width = c.width*x
  new_height = c.height*x
  [new_c, new_ctx]=newToolbox(new_width, new_height, (c?.getAttribute('id') or c?.getAttribute('origin')))
  new_ctx.drawImage(c, 0,0, new_width, new_height)
  nb(cb, new_c)

Franz.crop = crop = (c, p...) ->
  [cb, crop_x, crop_y, crop_width, crop_height] = fff(p, 0, 0, c.width/2, c.height/2)
  [new_c, new_ctx]=newToolbox(crop_width, crop_height, (c?.getAttribute('id') or c?.getAttribute('origin')))
  new_ctx.drawImage(c, crop_x, crop_y, crop_width, crop_height, 0,0,crop_width, crop_height)
  nb(cb,new_c)

