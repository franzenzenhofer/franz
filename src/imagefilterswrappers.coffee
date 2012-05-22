#test at http://www.arahaya.com/imagefilters/
#ImageFilters.ConvolutionFilter (srcImageData, matrixX, matrixY, matrix, divisor, bias, preserveAlpha, clamp, color, alpha)

#ImageFilters.Binarize (srcImageData, threshold)
#binarize = (c, cb, threshold=0.5) -> makeIfw(ImageFilters.Binarize, threshold)
#franz.binarize = binarize = (c, p...) -> [cb, threshold] = fff(p, 0.5); return makeIfw(ImageFilters.Binarize, threshold)
Franz.binarize = mF(ImageFilters.Binarize, 0.5)

#ImageFilters.BlendAdd (srcImageData, blendImageData, dx, dy)
#ImageFilters.BlendSubtract (srcImageData, blendImageData, dx, dy)
#ImageFilters.BoxBlur (srcImageData, hRadius, vRadius, quality)
Franz.boxBlur =  mF(ImageFilters.BoxBlur, 3,3,2)

#ImageFilters.GaussianBlur (srcImageData, strength)
Franz.gaussianBlur = mF(ImageFilters.GaussianBlur, 2)

#ImageFilters.StackBlur (srcImageData, radius)
Franz.stackBlur = mF(ImageFilters.StackBlur, 6)

#ImageFilters.Brightness (srcImageData, brightness)
Franz.brightness = mF(ImageFilters.brightness, 1)

#ImageFilters.BrightnessContrastGimp (srcImageData, brightness, contrast) #+/- 100
Franz.brightnessConstrastGimp = mF(ImageFilters.BrightnessContrastGimp, 50,50)

#ImageFilters.BrightnessContrastPhotoshop (srcImageData, brightness, contrast)
Franz.brightnessConstrastPhotoshop = mF(ImageFilters.BrightnessContrastPhotoshop, 50,50) #+/- 100

#ImageFilters.Channels (srcImageData, channel) #3 blue, #2 green
Franz.Channels = (channel_string) ->
  if channel_string is "blue" or channel_string is "b"
    channel = 3
  else if channel_string is "green" or channel_string is "g"
    channel = 2
  else
    channel = channel_string
  mF(ImageFilters.Channels, channel)

#NOT #ImageFilters.Clone (srcImageData)
#NOT #ImageFilters.CloneBuiltin (srcImageData)
#NOT - to investiagte #ImageFilters.ColorMatrixFilter (srcImageData, matrix)
#ImageFilters.ColorTransformFilter (srcImageData, redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset)
Franz.colorTransform = mF(ImageFilters.ColorTransformFilter, 1, 1, 1, 0, 0, 0) # mutiplyer between 0 and n # offeset between 0 and 255

#NOT #ImageFilters.Copy (srcImageData, dstImageData)
#NOT #ImageFilters.Crop (srcImageData, x, y, width, height)
#NOT #ImageFilters.CropBuiltin (srcImageData, x, y, width, height)
#ImageFilters.Desaturate (srcImageData)
#NOT; lets use a custom iplementation #Franz.desatureate = mF(ImageFilters.Desaturate)

#ImageFilters.DisplacementMapFilter (srcImageData, mapImageData, mapX, mapY, componentX, componentY, scaleX, scaleY, mode)

#ImageFilters.Dither (srcImageData, levels)
Franz.dither = mF(ImageFilters.Dither, 2) #between 1 and 32

#ImageFilters.Edge (srcImageData)
Franz.edge = mF(ImageFilters.Edge)

#ImageFilters.Emboss (srcImageData)
Franz.emboss = mF(ImageFilters.Emboss)

#ImageFilters.Enrich (srcImageData)
Franz.enrich = mF(ImageFilters.Enrich)

#NOT #ImageFilters.Flip (srcImageData, vertical)
#ImageFilters.Gamma (srcImageData, gamma)
Franz.gamma = mF(ImageFilters.Gamma, 2) #between 0 and 3

#ImageFilters.GrayScale (srcImageData)
#NOT NOW NATIVE #Franz.grayscale = mF(ImageFilters.Grayscale)

#ImageFilters.HSLAdjustment (srcImageData, hueDelta, satDelta, lightness) #beteen -180 and +180
Franz.HSLAdjustment =mF(ImageFilters.HSLAdjustment, 0, 0, 0)
#ImageFilters.Invert (srcImageData)
#NOT NOW NAtiVe # Franz.invert = mF(ImageFilters.Invert)
#ImageFilters.Mosaic (srcImageData, blockSize)
Franz.mosaic = mF(ImageFilters.Mosaic, 10)
#ImageFilters.Oil (srcImageData, range, levels)
Franz.oil = mF(ImageFilters.Oil, 4, 30) #range between 1 and 5(?), levels between 1 and 256
#ImageFilters.OpacityFilter (srcImageData, opacity)
#NOT; NOW NATIVE # Franz.opacity =mF(ImageFilters.OpacityFilter, 10) #?
#NOT NOW NATIVE #ImageFilters.Posterize (srcImageData, levels)
#Franz.posterize = mF(ImageFilters.Posterize, 8)

#NOT #ImageFilters.Rescale (srcImageData, scale)
#NOT #ImageFilters.Resize (srcImageData, width, height)
#NOT #ImageFilters.ResizeNearestNeighbor (srcImageData, width, height)
#ImageFilters.Sepia srcImageData)
#NOT #NOT NATIVE #Franz.sepia = mF(ImageFilters.Sepia)

#ImageFilters.Sharpen (srcImageData, factor)
Franz.sharpen = mF(ImageFilters.Sharpen, 3) #between 1 and n

#ImageFilters.Solarize (srcImageData)
#NOT# NOW native Franz.solarize = mF(ImageFilters.Solarize)
#NOT #ImageFilters.Transpose (srcImageData)
#ImageFilters.Twril (srcImageData, centerX, centerY, radius, angle, edge, smooth)
Franz.twirl = mF(ImageFilters.Twril, 0.5, 0.5, 100, 360) #center between 0 and 1 (ratio to original), radius in peixel, angle # forget edge and smooth
#
#
#todo todo
#http://mezzoblue.github.com/PaintbrushJS/demo/index.html http://github.com/mezzoblue/PaintbrushJS
#http://vintagejs.com/
#https://github.com/alexmic/filtrr
#overview: https://github.com/bebraw/jswiki/wiki/Image-manipulation
#
