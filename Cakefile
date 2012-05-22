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
    fs.writeFile 'lib/dev.coffee', appContents.join('\n\n'), 'utf8', (err) ->
      throw err if err
      exec 'coffee --compile lib/dev.coffee', (err, stdout, stderr) ->
        throw err if err
        console.log stdout + stderr
        fs.unlink 'lib/dev.coffee', (err) ->
          throw err if err
          console.log 'Done.'

task 'minify', 'Minify the resulting application file after build', ->
  exec 'java -jar "/Users/franzseo/bin/compiler.jar" --compilation_level SIMPLE_OPTIMIZATIONS --js lib/franz_imagefilters_fork.js lib/dev.js --js_output_file lib/min.js', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr

#task 'dev', 'setting up a dev compile and watch job', ->
#  exec 'coffee --join under-development.js --watch --compile --output devlib/ src/init.coffee src/helper.coffee', (err, stdout, stderr) ->
#    throw err if err
#    console.log stdout + stderr

task 'copy', 'copy to franzenzenhofer.github.com/franz/', ->
  exec 'cp -R /Users/franzseo/dev/franz /Users/franzseo/dev/franzenzenhofer.github.com/', (err, stdout, stderr) ->
    throw err if err
    console.log stdout + stderr