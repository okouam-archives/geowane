$.Controller("AddComment",
{
  init: function(el, options) {
    this.coordinator = options;
    this.comment_box = this.element.find("textarea")
  },

  ".cancel click": function() {
    this.coordinator.reset();
  },

  ".ok click": function() {
    var selected = this.coordinator.getSelectedRows();
    if (selected.length == 0) {
      this.coordinator.showSelectionError();
    } else {
      this.addComment(selected);
    }
  },

  addComment: function(selected) {
    var comment = this.comment_box.val();
    var locations = selected.map(function() { return $(this).attr("data-id") }).get();
    Comments.add(locations, comment, this.update.bind(this));
  },

  update: function(comments) {
    _.each(comments, function(comment) {
      var model = new Comment(comment);
      model.save();
    });
    this.coordinator.reset();
    this.coordinator.uncheckAll();
  },

  "ul a click": function(el) {
    this.comment_box.val($(el).text());
    return false;
  }
});