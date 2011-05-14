(function($) {

  Sammy = Sammy || {};

  Sammy.CommentWidget = function(app) {

    var widget;

    app.helpers({

      showCommentWidget: function(context, location_id) {
        var comments = [];
        if (location_id) {
          comments = Comment.find_by_location_id(location_id).map(function() {
            return this.to_hash();
          });
        }
        var output = JST['comment_widget']({comments: comments});
        widget = context.openFaceboxWidget(output, "comment_widget");
        widget.find("table a").click(function() {
          var textarea = widget.find("textarea");
          textarea.val($(this).text());
          return false;
        });
      },

      acceptComment: function(context, locations) {
        var new_comment = widget.find("textarea").val();
        $.ajax({
          type: 'POST',
          dataType: 'json',
          url: "/comments/collection_create",
          data: {"comment": new_comment, "locations": locations},
          success: function(comments) {
            _.each(comments, function(comment) {
              var model = new Comment(comment);
              model.save();
            });
            context.redirect("#/");
          }
        });
      }

    });
  };

})(jQuery);