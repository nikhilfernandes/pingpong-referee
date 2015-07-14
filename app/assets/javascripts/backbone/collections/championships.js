PingPong.Collections.Championships = Backbone.Collection.extend({
  model: PingPong.Models.Championship,

  initialize: function(){

  },

  url: function(){   
    return "/championships" 
  }
});
