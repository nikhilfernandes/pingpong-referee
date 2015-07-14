PingPong.Views.ChampionshipDetail = Backbone.View.extend({
  
  template: '#championship-detail-template',

  initialize: function(){
    _.bindAll(this, 'render');
  },

  render: function(){    
    $(this.el).html(Mustache.to_html($(this.template).html(), this.model.toJSON()));
    return this;
  },

});