ClassModel = require './class-model'
module.exports = class NewModel extends ClassModel

  insertOtherCode: (builder) ->
    console.log "implament in sub class"
    builder.push "helllllllllllllllllllllllo"
