/**
* Signup page module 
*/

module  Signup {

	window_id = "signup"

	signup_btn_html =
		<a class="btn btn-large btn-primary" data-toggle=modal href="#{window_id}">
			Sign up
		</a>

	private fld_username = 
		Field.text_field({Field.new with
			label: "Username",
			required: {with_msg: <>Please enter your username.</>},
			hint: <>Username is publicly visible. You will use it to sign in.</>
		})

	private fld_email =
		Field.email_field({Field.new with
			label: "Email",
			required: {with_msg: <>Please enter your email adress.</>},
			hint: <>Your activation link will be sent to this adress.</>
		})

	private fld_passwd =
		Field.passwd_field({Field.new with
			label: "Password",
			required: {with_msg: <>Please enter your password.</>},
			hint: <>Password should be at least 6 characters long and contain at least one digit.</>,
			validator: {passwd: Field.default_passwd_validator}
		})

		private fld_passwd2 =
		Field.passwd_field({Field.new with
			label: "Password",
			required: {with_msg: <>Please enter your password.</>},
			validator: {equals: fld_passwd, err_msg: <>Your password do not match.</>}
		})

	private client function signup() {

		email = Field.get_value(fld_email) ? error("Cannot read form email")
		username = Field.get_value(fld_username) ? error("Cannot read form name")
		passwd = Field.get_value(fld_passwd) ? error("Cannot read form password")
		Modal.hide(#{window_id})
		new_user = ~{email, username, passwd}
		#notice =
			match (User.register(new_user)) {
				case {success: _}:
					Page.alert("Congratulation! You are successful registered. You will receive an email with account activation instructions shortly.", "success")
				case {failure: msg}:
					Page.alert("Your registration failed: {msg}", "error")
			}
	}

	function modal_window_html() {

		form = Form.make(signup, {})
		fld = Field.render(form, _)
		form_body = 
			<>
				{fld(fld_username)}
				{fld(fld_email)}
				{fld(fld_passwd)}
				{fld(fld_passwd2)}
			</>
		win_body = Form.render(form, form_body)
		win_footer = 
			<a href="#" class="btn btn-primary btn-large" onclick={Form.submit_action(form)}>Sign up</>
		Modal.make(window_id, <>New to Birdy ?</>, win_body, win_footer, Modal.default_options)
	} 

}
