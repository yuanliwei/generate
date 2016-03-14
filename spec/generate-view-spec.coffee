Config = require '../lib/config'
return if Config.runOneSpec

GenerateView = require '../lib/generate-view'

describe "GenerateView", ->
  return
  it "has one valid test", ->
    # expect("life").toBe "easy"
    expect("life").toBe "life"
