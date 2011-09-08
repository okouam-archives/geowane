$.Controller("EditComments",
{
  init: function(el, options) {
    this.comment = this.element.find("textarea");
    this.editor = this.element.find(".editor");
    this.location_id = options.location_id;
    this.comment_list = this.element.find(".portlet-content > ul");
  },

  loadComments: function(comments) {
    var template = $.template(null, $("#comment-template").text());
    $.tmpl(template, comments).appendTo(this.comment_list);
    this.editor.hide();
    this.comment_list.show();
  },

  saveComment: function() {
    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: "/comments/collection_create",
      data: {"comment": this.comment.val(), "locations": [this.location_id]},
      success: function(comments) {
        this.loadComments(comments);
      },
      context: this
    });
  },
  "a:contains('(+)') click": function() {
    this.editor.show();
    this.comment_list.hide();
    return false;
  },
  "a:contains('Accept') click": function() {
    this.saveComment();
    this.editor.hide();
    this.comment_list.show();
    return false;
  },
  "a:contains('Cancel') click": function() {
    this.comment.val("");
    this.editor.hide();
    this.comment_list.show();
    return false;
  },
  "ul a click": function(el) {
    this.comment.val(el.text());
    return false;
  }
});