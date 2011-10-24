$.Controller("EditCategory",
{
  init: function(el, options) {
    this.location_id = options.location_id;
     $(el).chosen().change(function(evt, item) {
       if (item.options_index) {
          this.addCategory(item.value);
       } else {
          this.deleteCategory($(item).val());
       }

     }.bind(this));
  },

  deleteCategory: function(category_id) {
    if (confirm("Are you sure you want to delete this category?")) {
      Categories.remove([this.location_id], category_id);
    }
    return false;
  },

  addCategory: function(category_id) {
    Categories.add([this.location_id], category_id);
  }
});