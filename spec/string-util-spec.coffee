StringUtil = require '../lib/string-util'
stringUtil = new StringUtil()

describe 'StringUtil test', ->
  it "test format method", ->
    # gh_uji_kfg -> GhUjiKfg
    result = stringUtil.format "gh_uji_kfg",2,0
    expect(result).toBe "GhUjiKfg"



# GenerateView = require '../lib/generate-view'
#
#
# describe "GenerateView", ->
#   it "has one valid test", ->
#     expect("life").toBe "easy"
# StringUtil = require '../lib/string-util'
#
# stringUtil = new StringUtil()
#
# stringUtil.format 'sd_df_fg',2,0
