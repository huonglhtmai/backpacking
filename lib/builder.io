Builder := Object clone
Builder forward := method(
  if(call message argAt(1),
    tag(call message name, call message argAt(1), call message argAt(0))
    ,
    tag(call message name, call message argAt(0))
  )
)

Builder tag := method(name, nodes, 
  inner := ""
  while(nodes,
    if(nodes name != ";",
      inner = inner .. if(nodes argCount > 0,
        if(nodes argAt(1),
        a := nodes argAt(0) doInContext
        tag(nodes name, nodes argAt(1),a),
        tag(nodes name, nodes argAt(0))),
        doMessage(nodes))
    )
    nodes = nodes next
  )
  args := ""
  if(call message argAt(2),
    call evalArgAt(2) foreach(a, args = args .. " #{a argAt(0) doInContext asString}=\"#{a argAt(1) doInContext asString}\"" interpolate;)
  )
  "<#{name}#{args}>\n#{inner}\n</#{name}>\n" interpolate
)

Object curlyBrackets := method( call message arguments )

Builder html(
  head(title("Lazy Bricks, Lazy Mortar"))
  body(
    div(
      p({style = "foobar"}, "Here's a bit more Io...")
    #  p("Previously on Hackety Org..."
 		#		div("cat")
	  # 	)

    )
    div(
      p("Adieu, friends and uncles.")
    )
  )
) print