Server.start(
	Server.http,
	 	{ title:"Salut",
	 	page: function(){
	 		<div onclick={function(_) { #thankyou = "Thank you" }}>Click me</div>
	 		<div id="thankyou"/>
	 	}
	}
)