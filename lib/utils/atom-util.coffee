# 获取package 主模块路径
curMainModulePath = atom.packages.getLoadedPackage('generate').getMainModulePath()
console.log curMainModulePath

cp = curPackagePath
packagePath = cp.substr 0,cp.lastIndexOf 'generate.coffee'
console.log packagePath

# 获取文本&插入文本
if editor = atom.workspace.getActiveTextEditor()
  selection = editor.getSelectedText()
  editor.insertText "insert text"
