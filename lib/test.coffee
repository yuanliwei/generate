cp = atom.packages.getLoadedPackage('generate').getMainModulePath()
basePath = cp.substr 0,(cp.lastIndexOf('generate.coffee') - 1)
console.log basePath

################################################################

StringUtil = require "#{basePath}/string-util-s"
Filed = require "#{basePath}/model/filed"
filed = new Filed()

source = 'private String name = "value"; // this is comment'
filed.fromSource(source)
console.log "source - #{source.toString()}"
buffer = [];
source = filed.toSource buffer
console.log buffer.join ''
console.log 'private String name = ylw; // name string '
# 'private String name = ylw; // name string '
