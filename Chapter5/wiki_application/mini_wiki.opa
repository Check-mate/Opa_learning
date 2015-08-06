import	stdlib.tools.markdown
import stdlib.themes.bootstrap


database wiki {
  map(string, string) /page
  /page[_] = "This page is empty. Double-click to edit."
}

function render(markdown) {
	Markdown.xhtml_of_string(Markdown.default_options, markdown);
}

function load_data(topic) {
	/wiki/page[topic];
}

function save_data(topic, source) {
	/wiki/page[topic] <- source;
}

function edit(topic) {
	Dom.set_value(#content_edit, load_data(topic));
	Dom.hide(#show_container);
	Dom.show(#edit_container);
	Dom.give_focus(#content_edit);
}

function save(topic) {
	content = Dom.get_value(#content_edit);
	save_data(topic, content);
	#content_show = render(content);
	Dom.hide(#edit_container);
	Dom.show(#show_container);
}

function display(topic) {
	content = render(load_data(topic));
	xhtml = 
	<div class="navbar navbar-fixed-top">
		<div class=navbar-inner>
			<div class=container>
				<a class=brand href="#">
					Opa wiki
				</a>
			</div>
		</div>
	</div>
	<div class=container>
		<h1>About {topic}</>
			<div id=show_container>
				<span class="badge badge-info">Tip</span>
					<small>
						Double-click on the content to start editing it.
					</small>
			<div class="well well-small" id=content_show ondblclick={function(_) { edit(topic)}}>{content}
		</div>
	</div>
	<div id=edit_container hidden>
		<span class="badge badge-info">Tip</span>
			<small>
				Click outside the content box to confirm the changes.
			</small>
		<textarea id=content_edit rows=40 onblur={function(_){save(topic)}}/>
		</div>
	</div>
Resource.page("About {topic}", xhtml);
}

function start(url) {
  match (url) {
    case {path:[] ... } :
      display("Hello");
    case {~path ...} :
      display(String.capitalize(String.to_lower(String.concat("::", path))));
  }
}

Server.start(Server.http, // default port is 8080
	[
		{dispatch: start}
	]
);