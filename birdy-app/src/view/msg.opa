module MsgUI {

	function xhtml render(Msg.t msg) {
		msg_author = Msg.get_author(msg)
		<div class="well">
			<p clas="author-info">
				<strong><a href="/user/{msg_author}">@{msg_author}</a></strong>
				<span>{Date.to_string(Msg.get_create_at(msg))}</span>
			</p>
			<p>{List.map(render_segment, Msg.analyze(msg))}</p>
		</div>
	}

	private function render_segment(Msg.segment seg) {
		match (seg) {
			case ~{user}:
				<b><a class=ref-user href="/user/{user}">@{user}</a></b>
			case ~{topic}:
				<b><a class=ref-topic href="/topic/{topic}">@{topic}</a></b>
			case ~{link}:
				<a href={link}>{Uri.to_string(link)}</a>				
			case ~{text}:
				<>{text}</>
		}
	}

	window_id = "msgbox"

	function html() {
		match (User.get_logged_user()) {
			case {guest}: <></>
			case {user: _}:
				<a class="btn btn-primary pull-right" data-toggle=modal href="#{window_id}">
					<i class="icon-edit icon-white" />
					New message
				</a>
		}	
	}

	private preview_content_id = "preview_content"
	
	private input_box_id = "input_box"

	private	MAX_MSG_LENGHT = 140
	private MSG_WARN_LENGHT = 120

	private char_left_id = "char_left"
	private submit_btn_id = "submit_btn"

	function modal_window_html() {
		match (User.get_logged_user()) {
			case {guest}: <></>
			case ~{user}:
				win_body = 
					<textarea id={input_box_id} onready={update_preview(user)} onkeyup={update_preview(user)} placeholder="Compose your message" />
					<div id=#preview_container>
						<p class=badge>Preview</p>
						<div id={preview_content_id} />
					</div>
				win_footer = 
					<span class="char-wrap pull-left">
						<span id={char_left_id} class="char"/>
						character left
					</span>
					<button id={submit_btn_id} disabled=disabled class="pull-right btn btn-large btn-primary disabled" onclick={submit(user)}>Post
					</button>
				Modal.make(window_id, <>What's on your mind, huh?</>, win_body, win_footer, Modal.default_options)
		}
	}

	private client function get_msg(user) {
		Dom.get_value(#{input_box_id})
		|> Msg.create(user, _)
	}

	private client function close() {
		Modal.hide(#{window_id})
	}

	private function submit(user)(Dom.event _evt) {
		get_msg(user) |> Msg.store;
		Dom.clear_value(#{input_box_id});
		close();
		Client.reload();
	}

	private client function update_preview(user)(_) {
		msg = get_msg(user)
		#{preview_content_id} = render(msg)
		msg_len = Msg.lenght(msg)
		#{char_left_id} = MAX_MSG_LENGHT - msg_len
		remove = Dom.remove_class
		add = Dom.add_class
		remove(#{char_left_id}, "char-error");
		remove(#{char_left_id}, "char-warning");
		remove(#{submit_btn_id}, "disabled");
		Dom.set_enabled(#{submit_btn_id}, true);
		if (msg_len > MAX_MSG_LENGHT) {
			add(#{char_left_id}, "char-error");
			add(#{submit_btn_id}, "disabled");
			Dom.set_enabled(#{submit_btn_id}, false);
		}
		else if (msg_len < MSG_WARN_LENGHT) {
			add(#{char_left_id}, "char-warning");
		}
	}

}