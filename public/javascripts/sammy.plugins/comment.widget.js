(function($) {

  Sammy = Sammy || {};

  Sammy.CommentWidget = function(app) {

    var widget;

    app.helpers({

      showCommentWidget: function(context, url, text) {
        var comments = Comment.find_by_location_id(location_id).map(function() {
          return this.to_hash();
        });
        var output = JST['comment_widget']({comments: comments});
        widget = context.openFaceboxWidget(output);
      }

    });
  };

})(jQuery);