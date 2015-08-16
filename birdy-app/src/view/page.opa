/**  
* view/page.opa: Page module
*/
module Page {

  function page_template(title, content, notice) {
    html =
      <div class="navbar navbar-fixed-top">
        <div class=navbar-inner>
          <div class=container>
            {Topbar.html()}
          </div>
        </div>
      </div>
      <div class=background-pic>
        <div class=mlstate></div>
          <div id=#main class=container-fluid>
            <span id=#notice class=container>{notice}</span>
            {content}
            {Signin.modal_window_html()}
            {Signup.modal_window_html()}
            {MsgUI.modal_window_html()}
          </div>
       </div>
    Resource.page(title, html)
  }

  function alert(message, cl) {
    <div class="alert alert-alert">
      <button type="button" class="close" data-dismiss="alert">x</button>
      {message}
    </div>
  }

  // I) The web program begin here.
  function main_page() {
      main_page_content = 
        <div class=home-page>
          <h1>Birdy</h1>
            <h2>Micro-blogging platform. <br/>Built with <a target="_blank" href="http://opalang.org">Opa.</a></h2>
              <h3>By <a target="_blank" href="https://github.com/Check-mate">Lahmar Kamel.</a></h3>
          <p>{Signin.signin_btn_html}</p>
        </div>
      page_template("Birdy", main_page_content, <></>)
    }

}