Config = require '../../lib/config'
return if Config.runOneSpec
return
fs = require 'fs'
describe "test for file-util", ->

  it "test save file data", ->
    path = FileUtil.basePath() + '/data/'
    FileUtil.mkDir path
    FileUtil.writeToFile (path+'fileUtilTest.txt'),'test data!', (state) ->
      # console.log 'say hello...'
      expect(state).toBe(true)

  it  "create file if not exist", ->
    path = FileUtil.basePath() + '/data/'
    FileUtil.mkDir path
    filePath = path + 'testAppendFile.txt'
    fs.exists filePath, (exists) ->
      if not exists
        FileUtil.writeToFile filePath,'init test data!'

  it "test append to file", ->
    path = FileUtil.basePath() + '/data/'
    FileUtil.mkDir path
    filePath = path + 'testAppendFile.txt'
    stat = fs.statSync(filePath)
    oldSize = stat.size
    FileUtil.appendToFile filePath,"#{new Date().toLocaleString()} - this is append string ...\n", (result) ->
      stat = fs.statSync(filePath)
      # console.log "oldSize : #{oldSize} new Size : #{stat.size}"
      expect(stat.size > oldSize).toBe(true)
    # console.log "filepath - #{filePath}"
    # fs.fstat filePath,
