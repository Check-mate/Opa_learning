database int /counter;
function action(_) {
	/counter++;
	#msg = <div>Thank you, user number {/counter}!</div>
}
function page() {
	Db.remove(@/counter)
	<h1 id="msg">Hello</h1>
	<a onclick={action}>Click</a>
}
Server.start(
	Server.http, // default port is 8080
	[
	 	{	title:"Database Demo", page: page }
	]
)
