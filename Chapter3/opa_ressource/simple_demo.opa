function page() {
	<img src="resources/img/logo.png" alt="Opa"/>
	<hr/>
	<h1>This is a demo of a very simple Opa app.</h1>
}
Server.start(Server.http,
	[	{ resources: @static_resources_directory("resources") },
			{ register: {css:["/resources/css/style.css"]} },
		{ title: "Hello friend", page: page }
	]
)