

#Canip.vignette = (canvas, white, black, callback)
# white and black are between 0 and 1
Franz.vignette = (c, p...) ->
  [cb, white, black]=fff(p, 0.2,0.8)
  [new_c, new_ctx, new_imgd, new_pxs]=getToolbox(copy(c))
  outerRadius = Math.sqrt( Math.pow(new_c.width/2, 2) + Math.pow(new_c.height/2, 2) )
  new_ctx.globalCompositeOperation = 'source-over';
  gradient = new_ctx.createRadialGradient(new_c.width/2, new_c.height/2, 0, new_c.width/2, new_c.height/2, outerRadius);
  gradient.addColorStop(0, 'rgba(0,0,0,0)');
  gradient.addColorStop(0.65, 'rgba(0,0,0,0)');
  gradient.addColorStop(1, 'rgba(0,0,0,' + black + ')');
  new_ctx.fillStyle = gradient;
  new_ctx.fillRect(0, 0, new_c.width, new_c.height);

  new_ctx.globalCompositeOperation = 'lighter';
  gradient = new_ctx.createRadialGradient(new_c.width/2, new_c.height/2, 0, new_c.width/2, new_c.height/2, outerRadius);
  gradient.addColorStop(0, 'rgba(255,255,255,' + white + ')');
  gradient.addColorStop(0.65, 'rgba(255,255,255,0)');
  gradient.addColorStop(1, 'rgba(0,0,0,0)');
  new_ctx.fillStyle = gradient;
  new_ctx.fillRect(0, 0, new_c.width, new_c.height);

  nb(cb,new_c)

#Franz.curves
#Franz.desaturate
# Franz.screen
# Franz.viewfinder
#














Franz.schemer = (c, p...) ->
  #dlog('in schemer!!!')
  dlog(fff(p, 1,2,3,4,5,6,7,8, [], []))
  [cb, rA, gA, bA, aA, rV, gV, bV, aV] = fff(p, [],[],[],[],[],[],[],[])
  compare = (a,b) -> a-b
  rA = rA.sort(compare)
  dlog(rA)
  gA = gA.sort(compare)
  bA = bA.sort(compare)
  aA = aA.sort(compare)
  #rV = rV.sort(compare)
  #gV = gV.sort(compare)
  #bV = bV.sort(compare)
  #aV = aV.sort(compare)

  filter = (r,g,b,a) ->
    [r2,g2,b2,a2]=[r,g,b,a]
    if rA.length > 0
      for r_threshold,i in rA
          if r <= r_threshold
            r2 = rV[i] ? r_threshold
            break


    if gA.length > 0
      for g_threshold, i in gA
          if g <= g_threshold
            g2 = gV[i] ? g_threshold
            break


    if bA.length > 0
      for b_threshold, i in bA
          if b <= b_threshold
            b2 = bV[i] ? b_threshold
            break

    if aA.length > 0
      for a_threshold, i in aA
          if a <= a_threshold
            a2 = aV[i] ? a_threshold
            break
    #until b2 is 127 or b2 is 255 then dlog(b2)
    return [clamp(r2), clamp(g2), clamp(b2), clamp(a2)]
  Franz.rgba(c,cb,filter)

Franz.reduceAndReplace = (c, p...) ->
  #c64 = "0,0,0 255,255,255 116,67,53 124,172,186 123,72,144 100,151,79 64,50,133 191,205,122 123,91,47 79,69,0 163,114,101 80,80,80 120,120,120 164,215,142 120,106,189 159,159,159".split(" ");
  defaults= {}
  defaults.c64 = [
    [0,0,0]
    [255,255,255]
    [116,67,53]
    [124,172,186]
    [123,72,144]
    [100,151,79]
    [64,50,133]
    [191,205,122]
    [123,91,47]
    [79,69,0]
    [163,114,101]
    [80,80,80]
    [120,120,120]
    [164,215,142]
    [120,106,189]
    [159,159,159]
    ]
  [cb, replacementA] = fff(p, defaults.c64)
  if not Array.isArray(replacementA) then replacementA = defaults[replacementA]
  nr_of_buckets = replacementA.length
  dlog(replacementA)
  #sorted_replacementA = replacementA
  sorted_replacementA = replacementA.sort((a,b)->
    ((3*a[0]+4*a[1]+a[2])>>>3) - ((3*b[0]+4*b[1]+b[2])>>>3)
    )
  dlog(sorted_replacementA)
  filter = (r,g,b,a) ->
    brightness = (3*r+4*g+b)>>>3
    #the lower the bucket number, the darker
    bucket_nr = Math.floor(brightness / 256 * nr_of_buckets)
    #we need to sort the replacementA by reverse-brightness, too
    [r2,g2,b2] = sorted_replacementA[bucket_nr]
    #=rgb.split(',')
    return [r2, g2, b2, a]
  Franz.rgba(c,cb,filter)

Franz.c64 = (c, cb) -> Franz.reduceAndReplace(c,cb)

#funny func, returns a <pre class="ascii"> tag
Franz.ascii = (c, p...) ->
  [cb, ascii_string] = fff(p, '@GLftli;:,.  ')
  asciiA=asciistring.split('')
  nr_of_buckets=asciiA.length








Franz.removeNoise = (c, p...) ->
  [cb] = fff(p)
  [c, ctx, imgd, pxs] = getToolbox(c)
  [w,h]=[c.width,c.height]
  u8 = new Uint8Array(new ArrayBuffer(pxs.length))
  y = 0
  while y < h
    nextY = (if (y is h) then y else y+1)
    prevY = (if (y is 0) then 0 else y-1)
    x = 0
    yw = y*w
    while x < w
      i = (yw + x) * 4
      nextX = (if (x is w) then x else x+1)
      prevX = (if (x is 0) then 0 else x-1)
      iNext = (nextY*w+nextX)*4
      iPrev = (prevY*w+nextX)*4

      r = i; g = i+1; b = i+2; a = i+3

      minR = maxR = pxs[iPrev]
      r1 = pxs[r-4]; r2 = pxs[r+4]
      r3 = pxs[iNext]
      if (r1 < minR) then minR = r1
      if (r2 < minR) then minR = r2
      if (r3 < minR) then minR = r3
      if (r1 > maxR) then maxR = r1
      if (r2 > maxR) then maxR = r2
      if (r3 > maxR) then maxR = r3

      minG = maxG = pxs[iPrev+1]
      g1 = pxs[g-4]; g2 = pxs[g+4]
      g3 = pxs[iNext+1]
      if (g1 < minG) then minG = g1
      if (g2 < minG) then minG = g2
      if (g3 < minG) then minG = g3
      if (g1 > maxG) then maxG = g1
      if (g2 > maxG) then maxG = g2
      if (g3 > maxG) then maxG = g3

      minB = maxB = pxs[iPrev+2]
      b1 = pxs[b-4]; b2 = pxs[b+4]
      b3 = pxs[iNext+2]
      if (b1 < minB) then minB = b1
      if (b2 < minB) then minB = b2
      if (b3 < minB) then minB = b3
      if (b1 > maxB) then maxB = b1
      if (b2 > maxB) then maxB = b2
      if (b3 > maxB) then maxB = b3

      if r > maxR
        u8[r] = maxR
      else if r < minR
        u8[r] = minR
      if g > maxG
        u8[g] = maxG
      else if g < minG
        u8[g] = minG
      if b > maxB
        u8[b] = maxB
      else if b < minB
        u8[b] = minB
      u8[a]=pxs[a]
      x=x+1
    y=y+1
  new_c = Franz.byArray(u8, w,h)
  nb(cb, new_c)








Franz.curve = (c, p...) ->

  rc = [0, 0, 0, 1, 1, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6, 7, 7, 7, 7, 8, 8, 8, 9, 9, 9, 9, 10, 10, 10, 10, 11, 11, 12, 12, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16, 17, 17, 17, 18, 19, 19, 20, 21, 22, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 39, 40, 41, 42, 44, 45, 47, 48, 49, 52, 54, 55, 57, 59, 60, 62, 65, 67, 69, 70, 72, 74, 77, 79, 81, 83, 86, 88, 90, 92, 94, 97, 99, 101, 103, 107, 109, 111, 112, 116, 118, 120, 124, 126, 127, 129, 133, 135, 136, 140, 142, 143, 145, 149, 150, 152, 155, 157, 159, 162, 163, 165, 167, 170, 171, 173, 176, 177, 178, 180, 183, 184, 185, 188, 189, 190, 192, 194, 195, 196, 198, 200, 201, 202, 203, 204, 206, 207, 208, 209, 211, 212, 213, 214, 215, 216, 218, 219, 219, 220, 221, 222, 223, 224, 225, 226, 227, 227, 228, 229, 229, 230, 231, 232, 232, 233, 234, 234, 235, 236, 236, 237, 238, 238, 239, 239, 240, 241, 241, 242, 242, 243, 244, 244, 245, 245, 245, 246, 247, 247, 248, 248, 249, 249, 249, 250, 251, 251, 252, 252, 252, 253, 254, 254, 254, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255]
  gc = [0, 0, 1, 2, 2, 3, 5, 5, 6, 7, 8, 8, 10, 11, 11, 12, 13, 15, 15, 16, 17, 18, 18, 19, 21, 22, 22, 23, 24, 26, 26, 27, 28, 29, 31, 31, 32, 33, 34, 35, 35, 37, 38, 39, 40, 41, 43, 44, 44, 45, 46, 47, 48, 50, 51, 52, 53, 54, 56, 57, 58, 59, 60, 61, 63, 64, 65, 66, 67, 68, 69, 71, 72, 73, 74, 75, 76, 77, 79, 80, 81, 83, 84, 85, 86, 88, 89, 90, 92, 93, 94, 95, 96, 97, 100, 101, 102, 103, 105, 106, 107, 108, 109, 111, 113, 114, 115, 117, 118, 119, 120, 122, 123, 124, 126, 127, 128, 129, 131, 132, 133, 135, 136, 137, 138, 140, 141, 142, 144, 145, 146, 148, 149, 150, 151, 153, 154, 155, 157, 158, 159, 160, 162, 163, 164, 166, 167, 168, 169, 171, 172, 173, 174, 175, 176, 177, 178, 179, 181, 182, 183, 184, 186, 186, 187, 188, 189, 190, 192, 193, 194, 195, 195, 196, 197, 199, 200, 201, 202, 202, 203, 204, 205, 206, 207, 208, 208, 209, 210, 211, 212, 213, 214, 214, 215, 216, 217, 218, 219, 219, 220, 221, 222, 223, 223, 224, 225, 226, 226, 227, 228, 228, 229, 230, 231, 232, 232, 232, 233, 234, 235, 235, 236, 236, 237, 238, 238, 239, 239, 240, 240, 241, 242, 242, 242, 243, 244, 245, 245, 246, 246, 247, 247, 248, 249, 249, 249, 250, 251, 251, 252, 252, 252, 253, 254, 255]
  bc = [53, 53, 53, 54, 54, 54, 55, 55, 55, 56, 57, 57, 57, 58, 58, 58, 59, 59, 59, 60, 61, 61, 61, 62, 62, 63, 63, 63, 64, 65, 65, 65, 66, 66, 67, 67, 67, 68, 69, 69, 69, 70, 70, 71, 71, 72, 73, 73, 73, 74, 74, 75, 75, 76, 77, 77, 78, 78, 79, 79, 80, 81, 81, 82, 82, 83, 83, 84, 85, 85, 86, 86, 87, 87, 88, 89, 89, 90, 90, 91, 91, 93, 93, 94, 94, 95, 95, 96, 97, 98, 98, 99, 99, 100, 101, 102, 102, 103, 104, 105, 105, 106, 106, 107, 108, 109, 109, 110, 111, 111, 112, 113, 114, 114, 115, 116, 117, 117, 118, 119, 119, 121, 121, 122, 122, 123, 124, 125, 126, 126, 127, 128, 129, 129, 130, 131, 132, 132, 133, 134, 134, 135, 136, 137, 137, 138, 139, 140, 140, 141, 142, 142, 143, 144, 145, 145, 146, 146, 148, 148, 149, 149, 150, 151, 152, 152, 153, 153, 154, 155, 156, 156, 157, 157, 158, 159, 160, 160, 161, 161, 162, 162, 163, 164, 164, 165, 165, 166, 166, 167, 168, 168, 169, 169, 170, 170, 171, 172, 172, 173, 173, 174, 174, 175, 176, 176, 177, 177, 177, 178, 178, 179, 180, 180, 181, 181, 181, 182, 182, 183, 184, 184, 184, 185, 185, 186, 186, 186, 187, 188, 188, 188, 189, 189, 189, 190, 190, 191, 191, 192, 192, 193, 193, 193, 194, 194, 194, 195, 196, 196, 196, 197, 197, 197, 198, 199]
  [cb, r_c, g_c, b_c ]=fff(p, rc, gc, bc)
  filter = (r,g,b,a) -> [r_c[r],g_c[g],b_c[b],a]
  Franz.rgba(c,cb,filter)
