/** 
* controller/main.opa: Controller module
*/

module Controller {

  resources = @static_resource_directory("resources")

  // URL dispatcher of your application; add URL handling as needed
  function dispatcher(Uri.relative url) {
    match(url) {
      case {path: ["activation", activation_code] ...}:
        Signup.activate_user(activation_code)
      default:
        Page.main_page()
    
    }
  }

}

Server.start(Server.http, [
  { register:
    [ { doctype: { html5 } },
      { js: [ ] },
      { css: [ "/resources/css/style.css"] }
    ]
  },
  { resources: Controller.resources },
  { dispatch: Controller.dispatcher }
])
