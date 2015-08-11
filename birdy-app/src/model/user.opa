import stdlib.web.mail.smtp.client

abstract type User.name = string
abstract type User.status = {active} or {string activation_code}
abstract type User.info = 
{ 	Email.email email,
	string username,
	string passwd,
	User.status status,
	list(User.name) follow_users,
	list(Topic.t) follow_topics
}

module User {

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
		user = /birdy/users[status == ~{activation_code}]
			|> DbSet.iterator
			|> Iter.to_list
			|> List.head_opt
		match (user) {
			case {none}: {failure}
			case {some: user}:
				/birdy/users/[{username: user.username}] <- {user with status: {active}}
				{success}
		}
	}

	exposed function outcome register(user) {
		activation_code = Random.string(15)
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
				/birdy/users[{username: user.username}] <- user
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