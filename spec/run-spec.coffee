Config = require '../lib/config'
# return if Config.runOneSpec

describe "this is a main method", ->
  it "start a main run method", ->
    # Run = require '../lib/run'
    Run = require '../lib/get-html'
    Run.run()
    expect(true).toBe(true)
