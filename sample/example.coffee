$(window).load(() ->
  console.log('HI')
  _DEBUG_ = true
  dlog = (msg) -> console.log msg if _DEBUG_
  #dlog('DEBUG MODUS')
  img = $('#testimage')[0]
  window.img = img
  #$(img).bind('canvasready', (e, c)->)
  #
  # as we want to keep the examples here kinda consisten to what is in the documentation
  # we implement lots and lots of 'canvasready' eventlistener, in real life you wouldn't do this this way.
  $(img).on('canvasready', (e,c)->
    Franz.resize(c, 400,300, 200, 100, (c) ->
      c.id='resizedcanvas'
      $('#resize_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    Franz.scale(c, 0.1, (c) ->
      c.id='scaledcanvas'
      $('#scale_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    Franz.crop(c, 580, 330, 100, 100, (c) ->
      c.id='cropedcanvas'
      $('#crop_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    Franz.invert(c, (c) ->
      $('#invert_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    Franz.mosaic(c, 8, (c) ->
      $('#mosaic_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    Franz.binarize(c, 0.5, (c) ->
      $('#binarize_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    Franz.noise(c, 90, (c) ->
      $('#noise_placeholder').html(c)
      )
    )
  #vignette
  $(img).on('canvasready', (e,c)->
    Franz.vignette(c, 0.2, 0.8, (c) ->
      $('#vignette_placeholder').html(c)
      )
    )
  #saturate
  $(img).on('canvasready', (e,c)->
    Franz.saturate(c, 0.2, (c) ->
      $('#saturate_placeholder').html(c)
      )
    )
  #desaturate
  $(img).on('canvasready', (e,c)->
    Franz.desaturate(c, 0.4, (c) ->
      $('#desaturate_placeholder').html(c)
      )
    )
  #curve
  $(img).on('canvasready', (e,c)->
    Franz.curve(c, (c) ->
      $('#curve_placeholder').html(c)
      )
    )
  #screen
  $(img).on('canvasready', (e,c)->
    Franz.screen(c, 227, 12, 169, 0.9, (c) ->
      $('#screen_placeholder').html(c)
      )
    )

  #viewfinder border
  $(img).on('canvasready', (e,c)->
    Franz.viewfinder(c, null, (c) ->
      $('#viewfinder_placeholder').html(c)
      )
    )

  #oldschool border
  $(img).on('canvasready', (e,c)->
    Franz.oldschool(c, null, (c) ->
      $('#oldschool_placeholder').html(c)
      )
    )
  #many
  $(img).on('canvasready', (e,c)->
    actions =[ Franz.curve,  Franz.scale, Franz.screen, Franz.saturate, Franz.vignette, Franz.oldschool, Franz.toImage]
    params = [[],0.8,[227, 12, 169, 0.40],0.9,[0.2, 0.8],['./img/oldschool.png'],[]]
    Franz.many(c,actions, params, (c) ->
      $('#many_placeholder').html(c)
      )
    )

  #oil
  $(img).on('canvasready', (e,c)->
    oilbutton = $('<button>Click Me!</button>').on('click', () ->
      Franz.oil(c, 4, 30, (c) ->$('#oil_placeholder').html(c)
      )
    )
    $('#oil_placeholder').html(oilbutton)
  )

  #oil
  $(img).on('canvasready', (e,c)->
    button = $('<button>Click Me!</button>').on('click', () ->
      Franz.removeNoise(c, (c) ->$('#removenoise_placeholder').html(c)
      )
    )
    $('#removenoise_placeholder').html(button)
  )
#c64 = "0,0,0 255,255,255 116,67,53 124,172,186 123,72,144 100,151,79 64,50,133 191,205,122 123,91,47 79,69,0 163,114,101 80,80,80 120,120,120 164,215,142 120,106,189 159,159,159".split(" ");
  #schemer border
  $(img).on('canvasready', (e,c)->
    Franz.schemer(c,
      [127,255],
      [127,255],
      [127,255],
      [],
      [0,255],
      [0,255],
      [0,255],
      [],
      (c) ->
        $('#schemer_placeholder').html(c)
      )
    )

  #reduceAndReplace
  $(img).on('canvasready', (e,c)->
    Franz.reduceAndReplace(c, [[0,0,0], [255,255,255], [255,0,0], [0,255,0], [0,0,255]], (c) ->
    #Franz.reduceAndReplace(c, (c) ->

      $('#reduceandreplace_placeholder').html(c)
      )
    )

  #c64
  $(img).on('canvasready', (e,c)->
    Franz.c64(c, (c) ->
      $('#c64_placeholder').html(c)
      )
    )

  $(img).on('canvasready', (e,c)->
    #applyIfRgba = (c, franz_filter, franz_filter_arguments, if_filter, cb)
    Franz.applyIfRgba(c, Franz.blackWhite, [], ((r,g,b,a,i) ->
      (if (r>g or b>g) then true else false)), (c) ->
      $('#applyifrgba_placeholder').html(c)
      )
    )


  $(img).on('canvasready', (e,c)->
    Franz.preserveYellow(c, 127, 127, 60, (c) ->
      $('#preserveyellow_placeholder').html(c)
      )
    )

  #create the starting canvas
  Franz.byImage(img,(c) ->
    $('#byImage_placeholder').html(c)
    c.id='canvasbyimage'
    $(img).trigger('canvasready', c)
    )

  #Franz.byImage($('#viewfinder')[0],(c) ->
  #  Franz.toImage(c, (ii)->
  #    $('#byImage_placeholder').html(ii)
  #    )
  #  )
  #  $('#byImage_placeholder').html(c)
  #  #c.id='canvasbyimage'
 #  Franz.resize(c, 400, 400, (c) ->
  #  #$(img).trigger('canvasready', c)

  #    )
  #  )
  #todo when a canvas gets created, throw an event

#  Franz.byImage(img,(c)->
#    Franz.resize(c, 400,300, 200, 100, (c) ->
#      console.log('hallo')
#      dlog(c)
#      $('#resize_placeholder').html(c)
#      )
#    )
)
