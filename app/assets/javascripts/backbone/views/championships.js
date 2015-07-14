PingPong.Views.Championships = Backbone.View.extend({
  tagName: 'tbody',
  initialize: function(){
    _.bindAll(this, 'render');   
    
  },

  render: function(){
    var self = this;        
    this.$el.empty();
    this.collection.map(function (m) {
      var championships_view = (new PingPong.Views.Championship({model: m})).render().el;
      $(self.el).append(championships_view);
    });
    return self;
  }
});