$.Controller("AddCommentInline",
{
  init: function(el, options) {
    this.template = options;
  },

  "tbody .add-comment-inline click": function(el) {
    this.showWidget(el);
    return false;
  },

  "tbody .inline-picker input.cancel click": function() {
    this.hideWidget();
  },

  "tbody .inline-comment-picker input.ok click": function(el) {
    this.parent = $(el).closest("tr");
    var comment = this.parent.find("textarea").val();
    var locations = [this.parent.prev().data("id")];
    Comments.add(locations, comment, this.update.bind(this));
  },

  "tbody .inline-comment-picker ul a click": function(el) {
    $(el).closest("tr").find("textarea").val($(el).text());
    return false;
  },

  showWidget: function(el) {
    this.hideWidget();
    $(el).closest("tr").after("<tr class='inline-picker inline-comment-picker'><td colspan='7'><div class='inline-picker-wrapper'>" + this.template + "</div></td></tr>");
  },

  hideWidget: function() {
    this.element.find(".inline-picker").remove();
  },

  update: function(comments) {
    _.each(comments, function(comment) {
      var model = new Comment(comment);
      model.save();
    });
    this.hideWidget();
  }
});