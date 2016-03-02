  upperBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toUpperCase()

  lowerBegin = (item) ->
    item.replace /(\w)/,(match) ->
      match.toLowerCase()


  formatJavaType = (item) ->
    switch item
      when 'char' then 'String'
      when 'string' then 'String'
      when 'datetime' then 'String'
      when 'text' then 'String'
      when 'int' then 'int'
      when 'decimal' then 'double'
      when 'float' then 'float'
      when 'double' then 'double'
      else 'ERROR TYPE'

  formatDbType = (item) ->
    switch item
      when 'String' then 'TEXT'
      when 'int' then 'INTEGER'
      when 'float' then 'DOUBLE'
      else 'ERROR TYPE'

  formatJavaVarName = (item) ->
    lowerBegin item.replace /(_\w)/g, (match) ->
      match[1].toUpperCase()

  formatJSONVarName = (item) ->
    item.replace /([A-Z])/g, (match) ->
      match.toLowerCase() + '_'
    # public static String formatJSONVarName(String varName) {
    #     varName = lowerBegin(varName);
    #     StringBuilder s1 = new StringBuilder();
    #     for (int i = 0; i < varName.length(); i++) {
    #         char c = varName.charAt(i);
    #         if (c >= 'A' && c <= 'Z') {
    #             s1.append("_" + (char) (c + ('a' - 'A')));
    #         } else {
    #             s1.append(c);
    #         }
    #     }
    #     return s1.toString();
    # }
  console.log "hello"

  name = "asFhdYin"
  formatJSONVarName name
