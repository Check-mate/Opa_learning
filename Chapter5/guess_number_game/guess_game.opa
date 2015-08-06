function page() {
	secret = 1 + Random.int(100);
	<h1>Guess what is the number between 1 and 100 I'm thinking of?</h1>
	<input id=#guess/>
	<span onclick={show(secret, _)}>Check</>
	<div id=#message/>
}

function show_number(_) {
	#response = <>I was thinking of {1 + Random.int(100)}</>
}

function show(secret, _) {
	guess = String.to_int(Dom.get_value(#guess));
	message = 
		if (guess==secret) { <span class="success">Congrats! </span> }
		else if(guess<secret) { <>More than this</> }
		else { <>Less than this</> };
	#message = message;
}

Server.start(
	Server.http, // default port is 8080
	[
	 	{title:"My first game", ~page }
	]
)