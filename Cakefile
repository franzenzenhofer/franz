fs     = require 'fs'
{exec} = require 'child_process'

#IF A FILE GETS ADDED HERE; IT MUST GET ADDED TO THE DEV ENVIREMENT, TOO
appFiles  = [
  # omit src/ and .coffee to make the below lines a little shorter
#  'dataurls'
  'init'
  'helper'
  'resizer'
  'rotater'
  'merger'
  'adjuster'
  'meta'
  'simplergba'
  'advanced'
  'imagefilterswrappers'
]

task 'build', 'Build single application file from source files', ->
  appContents = new Array remaining = appFiles.length
  for file, index in appFiles then do (file, index) ->
    fs.readFile "src/#{file}.coffee", 'utf8', (err, fileContents) ->
      throw err if err
      appContents[index] = fileContents
      process() if --remaining is 0
  process = ->
    fs.writeFile 'lib/staging.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'sed -i "" "s/dlog/#-dlog/g" lib/staging.coffee', (err, stddout, stderr) ->
        throw err if err
        exec 'sed -i "" "s/##-/#/g" lib/staging.coffee', (err, stddout, stderr) ->
          throw err if err
          exec 'coffee --compile lib/staging.coffee', (err, stdout, stderr) ->
            throw err if err
            console.log stdout + stderr
            fs.unlink 'lib/staging.coffee', (err) ->
              throw err if err
              console.log 'Build staging.js - Done.'

task 'minify', 'Minify the resulting application file after build', ->
  exec 'java -jar "/Users/franzseo/bin/compiler.jar" --compilation_level SIMPLE_OPTIMIZATIONS --js lib/franz_imagefilters_fork.js lib/staging.js --js_output_file lib/min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

#task 'dev', 'setting up a dev compile and watch job', ->
#  exec 'coffee --join under-development.js --watch --compile --output devlib/ src/init.coffee src/helper.coffee', (err, stdout, stderr) ->
#    throw err if err
#    console.log stdout + stderr

task 'copy', 'copy to franzenzenhofer.github.com/franz/', ->
  exec 'cp /Users/franzseo/dev/franz/index.html /Users/franzseo/dev/franzenzenhofer.github.com/franz/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp /Users/franzseo/dev/franz/test.png /Users/franzseo/dev/franzenzenhofer.github.com/franz/test.png', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr
  exec 'cp -R /Users/franzseo/dev/franz/lib /Users/franzseo/dev/franzenzenhofer.github.com/franz/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr