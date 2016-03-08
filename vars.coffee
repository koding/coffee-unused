fs            = require 'fs'
walk          = require 'walk'
analyzeCode   = require './find-unused-vars'
processResult = require './process-result'

module.exports = (folder, skipParseError) ->

  lookForFile = {}
  pathToWalk  = folder
  walker      = walk.walk pathToWalk, {}

  walker.on "file", (root, fileStats, next) ->
    if root.indexOf('node_modules') is -1
      checkUsedFiles = {}
      fs.readFile fileStats.name, () ->
        if fileStats.name.endsWith '.coffee'
          openFile = "#{root}/#{fileStats.name}"
          lookForFile["#{openFile}"] = 1

    next()


  walker.on "end", () ->

    for path, value of lookForFile

      code = fs.readFileSync path, 'utf8'
      varsAndPath = analyzeCode code, path, skipParseError
      processResult varsAndPath.stats, varsAndPath.path

