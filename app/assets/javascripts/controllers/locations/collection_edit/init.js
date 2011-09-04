//= require_tree .

$(function($) {
  var featureReader = new FeatureReader($("table.main"));
  var locations = featureReader.getFeatures();
  $(".map.portlet").manage_map({locations: locations, footer: $(".map-footer")});
  $("table.list.updates").checkboxes();
  $("table.list.updates").add_category_inline($(".action-portlet.add_category select").html());
  $("table.list.updates").add_comment_inline($(".action-portlet.add_comment .portlet-content").html());
  $(".bulk-actions").bulk_actions();

  Comment.bind("add", function(new_comment) {
    var counter = $('tr[data-id=' + new_comment.attr("location_id") + '] a.comment_count');
    counter.text(parseInt(counter.text()) + 1);
  });

  var app = Sammy(function() {

    this.selected_locations = [];
    this.use(Sammy.FaceboxWidget);
    this.use(Sammy.MultiSelectorWidget, $("table.list.updates"));
    this.use(Sammy.CommentWidget);

    this.get("#/", function() {
      this.closeFacebox();
    });

    this.get("#/cancel", function(context) {
      context.redirect("#/");
    });

    this.get("#/comments/accept", function(context) {
      this.acceptComment(context, context.app.selected_locations);
    });

    this.get("#/comments/single/:location_id", function(context) {
      var location_id = context.params['location_id'];
      context.uncheckAll();
      context.select(location_id);
      this.showCommentWidget(context, location_id);
    });

  });

  $(function() {
    app.run('#/');
  });

});


