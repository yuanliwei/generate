cp = atom.packages.getLoadedPackage('generate').getMainModulePath()
basePath = cp.substr 0,(cp.lastIndexOf('generate.coffee') - 1)
console.log basePath

################################################################
 
stringUtil = require "#{basePath}/string-util-s"

name = "asFhdYin"
stringUtil.format name,1,3,4
# hello kkk
