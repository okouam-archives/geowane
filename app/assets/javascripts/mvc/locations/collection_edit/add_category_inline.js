$.Controller("AddCategoryInline",
{
  init: function(el, options) {
    this.categories = options;
  },

  "tbody .add-category-inline click": function(el) {
    this.showWidget(el);
    return false;
  },

  "tbody .inline-picker input.cancel click": function() {
    this.hideWidget();
  },

  "tbody .inline-category-picker input.ok click": function(el) {
    this.parent = $(el).closest("tr");
    var category = this.parent.find("select").val();
    var locations = [this.parent.prev().data("id")];
    Categories.add(locations, category, this.update.bind(this));
  },

  "tbody a.delete-category click": function() {
    if (confirm("Are you sure you want to delete this category?")) {
      var a = $(this);
      $.ajax({
        type: 'POST',
        url: $(this).attr("href"),
        dataType: 'script',
        data: {'_method': 'delete'},
        success: function() {
          a.closest("tr").remove();
          return false;
        }
      });
    }
    return false;
  },

  showWidget: function(el) {
    this.hideWidget();
    $(el).closest("tr").after("<tr class='inline-picker inline-category-picker'><td colspan='7'><div class='inline-picker-wrapper'><select>" + this.categories + "</select> <input class='button ok' type='button' value='Accept' /> <input class='cancel button' type='button' value='Cancel' /></div></td></tr>");
  },

  hideWidget: function() {
    this.element.find(".inline-picker").remove();
  },

  update: function(results) {
   this.redraw(results[0]);
   this.hideWidget();
  },

  redraw: function(tag) {
    var html = $(JST['templates/tag_template'](tag));
    var wrapper = this.parent.prev().find(".tags .list");
    html.appendTo(wrapper).find("a.tag_delete").bind("ajax:complete", function() {
      $(this).parent().remove();
    });
  }
});