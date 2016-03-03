cp = atom.packages.getLoadedPackage('generate').getMainModulePath()
basePath = cp.substr 0,(cp.lastIndexOf('generate.coffee') - 1)
console.log basePath

################################################################

StringUtil = require "#{basePath}/string-util-s"

name = "asFhdYin"
StringUtil.format name,1,3,4
# hello kkk

str = "hello {0} bye {1} , {1} hahaha {2}"
console.log StringUtil.formatStr str,'p0','p1','p2'

Filed = require "#{basePath}/model/filed"
filed = new Filed('String','name','ylw','name string')
buffer = [];
source = filed.toSource buffer
console.log buffer.join ''
console.log 'private String name = ylw; // name string '
# 'private String name = ylw; // name string '
