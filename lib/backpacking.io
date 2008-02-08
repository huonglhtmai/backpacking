doFile("lib/server.io")
doFile("lib/eio.io")

Socket

BackPack := Object clone do(
	handle := method(
		command := self request command
		
		self params := self request queryPath matchesOfRegex(self uri) all first captures
		if(command=="GET",self get(args),self post(args))
	)
	
	redirect := method(controller,
		redir := controller clone
		redir request := self request
		redir params := list(controller uri)
		redir get
	)
	
	get := method(
		render(self request queryPath slice(1))
	)
	
	post := method(
	)
	
	input := method (
		self request queryArgs
	)
	
	static := method(file,
		style := File clone with(file)
		style open
		lines := style readLines
		style close
		
		self request sendResponse (200, "OK")
		self request sendHeader ("Content-type", "text/HTML")
		self request endHeaders ()
		
		self request sendList(lines)
	)
	
	render := method(view,
		f := File with(view .. ".eio")
		if(f exists,
			f open
			parser := EIO clone
			lines := parser parse(f readLines,self)
			f close
			self request sendResponse (200, "OK")
			self request sendHeader ("Content-type", "text/HTML")
			self request endHeaders ()
		,
			lines := list("<html><title>NOT FOUND</title><body><h1>404 - File Not Found</h1></body></html>")
			self request sendResponse (404, "NOT FOUND")
			self request sendHeader ("Content-type", "text/HTML")
			self request endHeaders ()
		)
		
		self request sendList(lines) 
	)
)

BackPacking := WebRequest clone do(	
	controllers := list()
	
	controller := method(url,
		c := BackPack clone
		c uri := url
		controllers append(c)
		return c
	)
	
	static := method(file,url,
		c := BackPack clone
		c uri := url
		controllers append(c)
		c file := file
		c get := method( static(file) )
		return c
	)
	
	fourofour := method(
		lines := list("<html><title>NOT FOUND</title><body><h1>404 - File Not Found</h1></body></html>")
		self sendResponse (404, "NOT FOUND")
		self sendHeader ("Content-type", "text/HTML")
		self endHeaders ()
		self sendList(lines)
	)
	
	handleRequest := method(request,
		path := self queryPath
		meth := self command
		writeln("#{path} -- #{meth}" interpolate)
		controller := controllers select(controller, queryPath matchesRegex(Regex clone with(controller uri))) first clone
		controller request := self
		if(controller isNil,
			self fourofour
		,
			controller handle
		)
		self close
	)
)

BackPackServer := Server clone do(
	with := method(port,handler,
		setPort(port)
		self handler := handler
		return self
	)
	
	handleSocket := method(aSocket, 
		handler clone @handleSocket(aSocket)
	)
	
	serve := method(
		writeln("Starting server on port #{port}" interpolate)
		writeln("Hit CTRL-C to kill me")
		writeln("")
		self start
	)
)