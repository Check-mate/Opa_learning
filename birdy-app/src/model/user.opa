
import stdlib.web.mail.smtp.client


type User.name = string

type User.status = {active} or {string activation_code}

type User.info = 
{ 	Email.email email,
	string username,
	string passwd,
	User.status status,
	list(User.name) follow_users,
	list(Topic.t) follow_topics
}

private UserContext.t(User.logged) logged_user = UserContext.make({guest})

type User.t = { Email.email email, User.name username}

/** 
* model/user.opa : User module
*/

module User {

	@xmlizer(User.t) function user_to_xml(user) {
		<>{user.username}</>
	}

	@stringifier(User.t) function user_to_string(user) {
		user.username
	}

	function add_user(User.info user) {
		/birdy/users[username == user.username] <- user
	}

	function string get_name(User.t user) {
		user.username
	}

	function User.logged get_logged_user() {
		UserContext.get(logged_user)
	}

	function logout() {
		UserContext.set(logged_user, {guest})
	}

	private function send_registration_email(args) {
		from = Email.of_string("no-reply@{Data.main_host}")
		subject = "Welcome on Birdy"
		email = 
			<p>Hello {args.username}!</p>
			<p>Thank you for registering with Birdy.</p>
			<p>Activate your account by clicking 
				<a href="http://{Data.main_host}{Data.main_port}/activation/{args.activation_code}">here
				</a>
			</p>
			<p>Happy messaging !</p>
			<p>-----------------</p>
			<p>Kamel, developer of Birdy</p>
		content = {html: email}
		continuation = function(status) { Log.notice("[send_registration_email]", "send status={status}") }
		transporter = SmtpTransport.make(SmtpClient.default_options)
		options = ~{
			Email.default_options with
			subject, from,
			to: [args.email]
		}
		SmtpClient.try_send_async(options, content, transporter, continuation)
	}

	exposed function outcome activate_account(activation_code) {
		// search account with inactive status and match the activation_code given in parameter with those accounts
		user = /birdy/users[status == ~{activation_code}]
			|> DbSet.iterator
			|> Iter.to_list
			|> List.head_opt
		match (user) {
			case {none}: {failure}
			case {some: user}: 
				add_user({user with status: {active}})
				{success}
			}
	}

	exposed function outcome register(user) {
		activation_code = Random.string(30)
		status = 
		#<Ifstatic:NO_ACTIVATION_MAIL>
		{active}
		#<Else>
		{~activation_code}
		#<End>
		user = 
			{
				email: user.email,
				username: user.username,
				passwd: user.passwd,
				follow_users: [],
				follow_topics: [],
				~status
			}
		x = ?/birdy/users[{username: user.username}]
		match(x) {
			case {none}:
				/birdy/users[{username: user.username}] = user
				#<Ifstatic:NO_ACTIVATION_MAIL>
				void
				#<Else>
					send_registration_email({~activation_code, username:user.username, email:user.email})
				#<End>
				{success}
			case {some: _}:
				{failure: "User with the given name already exist."}
		}
	}

}