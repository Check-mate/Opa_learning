import	stdlib.tools.markdown

function render(markdown) {
	Markdown.xhtml_of_string(Markdown.default_options, markdown);
}