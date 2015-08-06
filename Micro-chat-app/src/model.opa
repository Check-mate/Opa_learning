database chat {
  int /counter
}

type message = {
	string author,
	string text,
} or {
	string notif
}

module Model {

	private Network.network(message) room = Network.cloud("room")


	exposed function broadcast_message(message) {
		Network.broadcast(message, room);
	}

	function broadcast_notif(author) {
		function (_) { broadcast_message({ notif: "{author} has joined the room"}) }
	}

	function register_message_callback(callback) {
		Network.add_callback(callback, room);
	}

	function new_author() {
		Random.string(8);
	}

}
