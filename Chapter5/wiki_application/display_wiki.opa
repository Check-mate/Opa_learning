function display() {
	content = render(load_data(topic));
	xhtml = 
		<header>
			<h3>OpaWiki</h3>
		</header>
		<article>
			<h1>About {topic}</h1>
				<div id=show_container>
					<small><strong>Tip:</strong> Double-click on the content to start editing it</small>
					<section id=content_show ondblclick={function(_) { edit(topic) }}>{content}</section>
				</div>
				<div id=edit_container hidden>
					<small><strong>Tip:</strong> Click outside of the content box to save changes.</small>
					<textarea id=content_edit rows=30 onblur={function(_) { save(topic) }}/>
				</div>
		</article>;
Resources.page("About {topic}", xhtml);
}