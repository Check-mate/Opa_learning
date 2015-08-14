abstract type Msg.t = 
	{	string		content,
		User.t 		author,
		Date.date	create_at
}

type Msg.segment = 
	{ string text } or
	{ Uri.uri link } or
	{ User.name user } or
	{ Topic.t topic }

/** 
* model/msg.opa : Message module
*/

module  Msg {

	function Msg.t create(User.t author, string content) {
		{ ~content, ~author, create_at: Date.now()}
	}

	function get_author(Msg.t msg) { msg.author }
	function get_create_at(Msg.t msg) { msg.create_at }

	function list(Msg.segment) analyze(Msg.t msg) {
		word = parser { case word=([a-zA-Z0-9_\-]+) -> Text.to_string(word) }
		element = parser {
			case "@" user=word: ~{user}
			case "#" topic=word: ~{topic}
			case &"http://" url=Uri.uri_parser: {link: url}
			}
		segment_parser = parser {
			case ~element: element
			case text=word: ~{text}
			case c=(.): {text: Text.to_string(c)}
			}
		msg_parser = parser { case res=segment_parser*: res }
		Parser.parse(msg_parser, msg.content)
	}

	function store(Msg.t msg){
		void
	}
	
	function int lenght(Msg.t msg) {
		String.length(msg.content)
	}
}
