signinup_btn_html = 
	<ul class="nav pull-right">
		<li>
			<a data-toggle=modal href="#{Signin.window_id}">Sign in</a>
		</li>
	</ul>

/** 
* view/topbar.opa: Topbar module
*/

module  Topbar {

	function html() {
		// <a class=brand href="/">
		// Birdy
		// </a> <+>
		MsgUI.html() <+>
		user_menu()
	}

	function user_menu() {
		match (User.get_logged_user()) {
			case {guest}: signinup_btn_html
			case ~{user}: user_box(user.username)
		}
	}

	private function logout(_) {
		User.logout();
		Client.reload()
	}

	private function user_box(username) {
		id = Dom.fresh_id()
		<ul id={id} class="nav pull-right">
			<li class="dropdown">
				<a href="#" class="dropdown-toogle" data-toggle="dropdown">
					{username}
					<b class="caret"></b>
				</a>
				<ul class=dropdown-menu>
					<li><a onclick={logout} href="#">Sign out</></>
				</ul>
			</li>
		</ul>
	}
}
