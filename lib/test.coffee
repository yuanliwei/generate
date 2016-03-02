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

  format = () ->
    args = arguments
    console.log args
    item = args[0]
    # options=args.slice 1,3
    console.log item
    # console.log options
    console.log args.slice
    # console.log args.slice
  #  public static String format(String str, int... option) {
  #       String tem = str;
  #       for (int i = 0; i < option.length; i++) {
  #           switch (option[i]) {
  #               case 0:
  #                   tem = upperBegin(tem);
  #                   break;
  #               case 1:
  #                   tem = lowerBegin(tem);
  #                   break;
  #               case 2:
  #                   tem = formatJavaVarName(tem);
  #                   break;
  #               case 3:
  #                   tem = formatJSONVarName(tem);
  #                   break;
  #               case 4:
  #                   tem = formatJSONVarName(tem);
  #                   break;
  #               case 5:
  #                   tem = formatJavaType(tem);
  #                   break;
  #               case 6:
  #                   tem = formatDbType(tem);
  #                   break;
   #
  #               default:
  #                   throw new IllegalArgumentException("error : " + option[i] + " illegal argument");
  #           }
  #       }
  #       return tem;
   #
  #   }
  #
  console.log "hello"

  name = "asFhdYin"
  format name,1,3,4
