#multiactions
Franz.many = (c, p...) ->
  [cb, actions, params] = fff(p)
  cbr(cb)
  action = actions?.shift() ? null
  paramA = params?.shift() ? []
  until Array.isArray(paramA) then paramA = [paramA]
  if actions.length > 0
    action(c, ((c)->Franz.many(c, cb, actions, params)), paramA...)
  else
    action(c, cb, paramA)

Franz.applyIfRgba = (c, franz_filter, franz_filter_arguments, if_filter, cb) ->
  orig_c = Franz.copy(c)
  [orig_c, orig_ctx, orig_imgd, orig_pxs]=Franz.getToolbox(orig_c)
  Franz.many(c, [franz_filter], [franz_filter_arguments], (c)->
    [c, ctx, imgd, pxs]=Franz.getToolbox(c)
    [new_c, new_ctx, new_imgd, new_pxs]=Franz.newToolbox(c)
    filter = (r,g,b,a,i) ->
      if if_filter(r,g,b,a,i)
        return [pxs[i],pxs[i+1],pxs[i+2],pxs[i+3]]
      else
        #return [orig_pxs[i],orig_pxs[i+1],orig_pxs[i+2],orig_pxs[i+3]]
        return [r,g,b,a,i]
    Franz.rgba(orig_c,cb,filter)
  )


#some simple adhoc functions
Franz.preserveGreen = (c, cb) -> Franz.applyIfRgba(c, Franz.blackWhite, [], ((r,g,b,a,i) -> (if (r>g or b>g) then true else false)), cb)
Franz.preserveBlue = (c, cb) -> Franz.applyIfRgba(c, Franz.blackWhite, [], ((r,g,b,a,i) -> (if (r>b or g>b) then true else false)), cb)
Franz.preserveRed = (c, cb) -> Franz.applyIfRgba(c, Franz.blackWhite, [], ((r,g,b,a,i) -> (if (g>r or b>r) then true else false)), cb)
Franz.preserveYellow = (c, cb) -> Franz.applyIfRgba(c, Franz.blackWhite, [], ((r,g,b,a,i) -> (if (r>127 and g>127 and b < 50) then FALSE else TRUE)), cb)