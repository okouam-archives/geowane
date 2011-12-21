GeoCMS.Views.LightboxCommentEditor = Backbone.View.extend({

  NEW_COMMENT_TEMPLATE:
    "<li> \
      <div class='details'> \
        <span class='created_at'><%= created_at %></span> \
        <br> \
        <span class='username'><%= login %></span> \
        <p><%= comment %></p> \
      </div> \
      <div class='clear'></div> \
    </li>",

  events: {
    "click .actions .blue-button": "save"
  },

  save: function() {
    var comment = $(this.el).find("textarea").val();
    var self = this;
    $("body").css("cursor", "wait");
    $.ajax({
      url: "/api/locations/" + this.id + "/comments",
      data: {comment: comment, _method: "put", user_id: window.current_user.id},
      type: "POST",
      success: function(data) {
        $(this.el).find("textarea").val("");
        $("ul.comments").append(_.template(self.NEW_COMMENT_TEMPLATE, data));
        $("body").css("cursor", "inherit");
      }
    })
  }

});

