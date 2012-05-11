#INIT STUFF
Franz = {};
window.Franz = Franz
Franz._DEBUG_ = _DEBUG_ = true;
TRUE = true
FALSE = false

#PRIVATE HELPER

#debug helper
dlog = (msg) -> console.log(msg) if _DEBUG_

#callback required
#some functions can't work without callback
cbr = (cb,function_name) -> until cb then throw new Error('Callback required for '+function_name)

#stupid isfunction check
isFunction = (functionToCheck) ->
  #dlog('in is function')
  #dlog(functionToCheck)
  # getType = {} does not work, because Google Closure Minification then makes a stupid error
  # seems it translates any not used object into void 0
  getType = []
  #dlog(getType)
  return functionToCheck and getType.toString.apply(functionToCheck) is '[object Function]'

#nonblocker helper
nb = (cb, p...) ->
  #dlog('in NB')
  if cb and isFunction(cb)
    window.setTimeout(cb, 0, p...)
  return p?[0]

fff = (params,defaults...) ->
  #dlog('in fff')
  #dlog('a')
  first_func = null
  #dlog('b')
  p2 = []
  #dlog('c')
  i = 0
  #dlog('d')
  for par in params
    #dlog('e')
    do (par) ->
      #dlog('f')
      #dlog(par)
      if isFunction(par) and not first_func
        #dlog('g')
        first_func = par
        #dlog('h')
      else
        #dlog('i')
        p2.push(par)
        #dlog('j')
  #dlog('k')
  for d, i in defaults
    #dlog('l')
    do (d) ->
      #dlog('m')
      p2[i] ?= d
      #dlog('n')

  #dlog('o')
  if not first_func
    #dlog('p')
    # we return a dummy callback
    first_func = (c)->null
    #dlog('q')
  p2.unshift(first_func)
  #dlog('r')
  #dlog('end of fff')
  return p2

#variation of fff
#returns fals as the first array argument, if no callback is given
fffr = (params,defaults...) ->
  first_func = null
  p2 = []
  i = 0
  for par in params
    do (par) ->
      if isFunction(par) and not first_func
        first_func = par
      else
        p2.push(par)

  for d, i in defaults
    do (d) ->
      p2[i] ?= d

  if not first_func
    # this is the difference
    first_func = false
  p2.unshift(first_func)
  return p2


#PRIVATE IMAGEFILTERS WRAPPER HELPFER

#imagefilters wrapper
ifw = (c, cb, image_filters_func, p...) ->
  [c,ctx,imgd, px] = getToolbox(c)
  [new_c,new_ctx,new_imgd, new_px] = newToolbox(c)
  nb(() -> new_ctx.putImageData(image_filters_func(imgd, p...),0,0))
  nb(cb,new_c)

#make IMAGEFILTERS wrapper
mF = (image_filters_func, defaults...) ->
  return (c, p...) ->
    defaulted_p = fff(p,defaults)
    cb = defaulted_p.shift()
    ifw(c, cb, image_filters_func, defaulted_p...)

#END PRIVATE HELPFER