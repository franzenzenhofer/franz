#adjust the r,g,b,a values via addtions
Franz.rgbaAd = (c, p...) ->
  [cb, rv, gv, bv, av] = fff(p,0,0,0,0)
  Franz.rgba(c, cb, (r,g,b,a)->[clamp(a+rv),clamp(g+gv),clamp(b+bv),clamp(a+av)])
#make all values t lighter
Franz.adBrighter = (c, p...) ->
  [cb, t]=fff(p,0)
  Franz.rgbaAd(c, t, t, t, 0, cb)
#make everything darker
Franz.adDarker = (c, p...) ->
  [cb, t]=fff(p,0)
  Franz.brighter(c,t*-1,cb)
#change the alpha value
Franz.adOpacity = (c, p...) ->
  [cb, t]=fff(p,0)
  Franz.rgbaAd(c, 0,0,0,t,cb)

#i like the main methods to deal with values in percentages, meaning between 0 and n
#multiply, values should be between 0 and n
Franz.rgbaMultiply = (c, p...) ->
  [cb, rv, gv, bv, av] = fff(p,1,1,1,1)
  Franz.rgba(c,cb,(r,g,b,a)->[clamp(a*av),clamp(g*gv),clamp(b*bv),clamp(a*av)])

#make brighter between 0 and n
Franz.brighter=(c,p...)->
  [cb, p]=fff(p,1)
  Franz.rgbaMultiply(c, p,p,p,1,cb)

Franz.darker=(c,p...)->
  [cb, p]=fff(p,1)
  p=2-p
  Franz.rgbaMultiply(c, p,p,p,1,cb)

Franz.opacity = (c,p...) ->
  [cb,o]=fff(p,1)
  Franz.rgbaMultiply(c,1,1,1,o,cb)