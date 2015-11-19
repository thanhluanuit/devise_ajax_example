$(document).ready(function(){
  Authentication.callbackSubmit();
});

var Authentication = {
  callbackSubmit: function(){
    var self = this;

    $("form").bind("ajax:success", function(e, response, status, xhr){
      if(response.success){
        window.location.reload();
      }else{
        self.errorsFromServer();
      }
    });
  },
  errorsFromServer: function(){
    // Show error to UI
    alert('Failed ...');
  }
}
