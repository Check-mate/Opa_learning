type Topic.t = string

type Topic.user = 
	{ 	User.t data,
		string passwd,
		User.status status,
		list(User.name) follow_users,
		list(Topic.t) follow_topics
	}

type User.logged = {guest} or {User.t user}

/** 
* model/topic.opa : Topic module
*/

module  Topic {

	private function User.t mk_view(User.info info) {
		{username: info.username, email: info.email}
	}

	exposed function outcome(User.t, string) login(string username, string passwd) {
		// get user in the database
		x = ?/birdy/users[username == username]
		// check if the user stored in 'x' exist.
		match (x) {
			case {none}: {failure: "This user doesn't exist."}
			case {some: user}:
				match (user.status) {
					case {activation_code: _}:
					{failure: "You need to activate your account by clicking the link we sent you by email."}
					case {active}:
						if (user.passwd == passwd) {
							user_view = mk_view(user)
							UserContext.set(logged_user, {user: user_view})
							{success: user_view}
						}
						else
							{failure: "Incorrect password. Try again."}
			}
		}
	}

}