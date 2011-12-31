GeoCMS.Views.Lightbox.CommentEditor = Backbone.View.extend({

  NEW_COMMENT_TEMPLATE:
    "<% for (var i = 0; i < models.length; i++) { %> \
     <li> \
      <div class='details'> \
        <span class='created_at'><%= models[i].attributes.created_at %></span> \
        <br> \
        <span class='username'><%= models[i].attributes.login %></span> \
        <p><%= models[i].attributes.comment %></p> \
      </div> \
      <div class='clear'></div> \
    </li> \
    <% } %>",

  events: {
    "click .actions .blue-button": "save"
  },

  initialize: function(options) {
    this.associate(options.location);
    this.location.comments.fetch();
  },

  associate: function(location) {
    if (this.location) this.location.comments.unbind("reset");
    this.location = location;
    this.location.comments.unbind("reset");
    this.location.comments.bind("reset", this.render, this);
  },

  render: function() {
    $("ul.comments").html(_.template(this.NEW_COMMENT_TEMPLATE, this.location.comments));
  },

  save: function() {
    var text = $(this.el).find("textarea").val();
    this.location.comments.create({comment: text, user_id: window.current_user.id});
  }

});

