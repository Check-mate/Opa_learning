module View {

  /**
  function page_template(title, content) {
    html =
      <div class="navbar navbar-fixed-top">
        <div class=navbar-inner>
          <div class=container>
            <a class=brand href="./index.html">chat</>
          </div>
        </div>
      </div>
      <div id=#main class=container-fluid>
        {content}
      </div>
    Resource.page(title, html)
  }
*/
  function page_template(title, content) {
    html =
      <div class="navbar navbar-inverse navbar-fixed-top">
        <div class=navbar-inner>
          <div class=container>
            <div id=#logo />
          </div>
        </div>
      </div>
      <div id=#main>
        {content}
      </div>
    Resource.page(title, html)
  }

  function chat_html(author) {
    <div id=#conversation onready={function(_) { Model.register_message_callback(user_update) }}>
      <div id=#hello class="navbar navbar-fixed-top">Hello user {author}</>
      <button class="btn btn-primary" type=button onclick={Model.broadcast_notif(author)}>
        On clicking the button i confirm to others that i'm in the chatroom.
      </button>
    </div>
    <div id=#footer class="navbar navbar-fixed-top">
      <div class=container>
        <div class=input-append>
            <input id=#entry class=input--xxlarge type=text onnewline={function(_) { broadcast_message(author) }}>
          <button class="btn btn-primary" type=button onclick={function(_) { broadcast_message(author) }}>Post</>
        </div>
      </div>
    </div>
  }

  function user_update(message msg) {
    line = match (msg) {
      case ~{author, text}:
        <div class="row-fluid line">
          <div class="span1 userpic">
            <img src="/resources/img/user.png" alt="User"/>
          </div>
          <div class="span2 user">{author}:</>
          <div class="span9 message">{text}</>
        </div>
      case ~{notif}:
        <div class="row-fluid line">
          <div id=#myself class="span1">
            Admin
          </div>
          <div class="span2 user">System</>
          <div class="span9 message">{notif}</>
        </div>
    }
    #conversation =+ line;
    Dom.scroll_to_bottom(#conversation);
  }

  function broadcast_message(author) {
    text = Dom.get_value(#entry);
    Model.broadcast_message(~{author, text});
    Dom.clear_value(#entry);
  }

  function default_page() {
    author =  Model.new_author();
    // author = "Kamel";
    page_template("Opa chat", (chat_html(author)))
  }

}
