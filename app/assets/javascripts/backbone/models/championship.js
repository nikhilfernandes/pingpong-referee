PingPong.Models.Championship = Backbone.Model.extend({
  
 url: function() {         
    return "/championships/"+this.get("id");
  },
});