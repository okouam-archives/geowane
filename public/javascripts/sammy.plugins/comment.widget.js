(function($) {

  Sammy = Sammy || {};

  Sammy.CommentWidget = function(app) {

    var widget;

    app.helpers({

      showCommentWidget: function(context, location_id) {
        var comments = Comment.find_by_location_id(location_id).map(function() {
          return this.to_hash();
        });
        var output = JST['comment_widget']({comments: comments, location_id: location_id});
        widget = context.openFaceboxWidget(output);
      },

      acceptComment: function(context, location_id) {
        var new_comment = widget.find("textarea").val();
        $.ajax({
          type: 'POST',
          dataType: 'json',
          url: "/locations/" + location_id + "/comments",
          data: {"comment[comment]": new_comment},
          success: function(data) {
            new Comment(data).save();
            context.redirect("#/");
          }
        });
      }

    });
  };

})(jQuery);