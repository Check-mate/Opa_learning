module Page {

  function page_template(title, content, notice) {
    html =
      <div class="navbar navbar-fixed-top">
        <div class=navbar-inner>
          <div class=container>
            <a class=brand href="./index.html">birdy</>
          </div>
        </div>
      </div>
      <div id=#main class=container-fluid>
        <span id=#notice class=container>{notice}</span>
        {content}
        {Signup.modal_window_html()}
      </div>
    Resource.page(title, html)
  }
   
  function alert(message, cl) {
    <div class="alert alert-{cl}">
      <button type="button" class="close" data-dismiss="alert">x</button>
      {message}
    </div>
  }

  function main_page() {
      main_page_content = 
        <div class=hero-unit>
          <h1>Birdy</h1>
            <h2>Micro-blogging platform. <br/>Built with <a href="http://opalang.org">Opa.</a>
            </h2>
          <p>{Signup.signup_btn_html}</p>
        </div>
      page_template("Birdy", main_page_content, <></>)
    }

  function default_page() {
    content =
      <div class="hero-unit">
        Page content goes here...
      </div>
    page_template("Default page", content, <></>)
  }

}
