$.Controller("EditCategory",
{
  init: function(el, options) {
    this.location_id = options.location_id;
  },

  ".cancel click": function() {
    this.hideCategoryPicker();
  },

  ".ok click": function() {
    this.addCategory(this.element.find("select").val());
  },

  ".pick-category click": function() {
    this.showCategoryPicker();
  },

  "a.delete-category click": function(el) {
    if (confirm("Are you sure you want to delete this category?")) {
      var a = $(el);
      $.ajax({
        type: 'DELETE',
        url: a.attr("href"),
        success: function() {
          a.closest("span").remove();
          return false;
        }
      });
    }
    return false;
  },

  addCategory: function(category_id) {
    Categories.add([this.location_id], category_id, this.update.bind(this));
  },

  hideCategoryPicker: function() {
    this.element.find(".category-picker").hide();
  },

  showCategoryPicker: function() {
    this.element.find(".category-picker").show();
  },

  update: function(tag) {
    this.redraw(tag);
    this.hideCategoryPicker();
  },

  redraw: function(tag) {
    var html = $(JST['templates/tag_template'](tag[0]));
    var wrapper = this.element.find(".tags .list");
    html.appendTo(wrapper);
  }
});