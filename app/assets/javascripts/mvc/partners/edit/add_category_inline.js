$.Controller("AddCategoryInline",
{
  init: function() {
    this.partner_id = $("tbody").data("partner-id");
    var self = this;
    Categories.fetchAll(function(categories) {
      self.categories = categories;
    });
  },

  "tbody .add-category-inline click": function(el) {
    this.showWidget(el, this.categories);
    return false;
  },

  "tbody .inline-picker input.cancel click": function() {
    this.hideWidget();
  },

  "tbody .inline-picker input.ok click": function(el) {
    this.parent = $(el).closest("tr");
    var category_id = this.parent.find("select").val();
    var partner_category_id = [this.parent.prev().data("id")];
    PartnerCategories.createMapping(this.partner_id, partner_category_id, category_id, this.update.bind(this));
  },

  "tbody a.inline-delete click": function(el) {
    if (confirm("Are you sure you want to remove this category?")) {
      var link = $(el);
      var partner_category_id = link.closest("tr").data("id");
      var mapping_id = link.closest("span").data("id");
      PartnerCategories.removeMapping(this.partner_id, partner_category_id, mapping_id, function() {
        link.closest("span").remove();
        return false;
      });
    }
    return false;
  },

  showWidget: function(el, categories) {
    this.hideWidget();
    var listTemplate = $.template("inline-category-picker",
      "<tr class='inline-picker inline-category-picker'> \
        <td colspan='5'> \
          <div class='inline-picker-wrapper'> \
            <select>{{tmpl($data.results) \"nested\"}}</select>  \
            <input class='button ok' type='button' value='Accept' /> \
            <input class='cancel button' type='button' value='Cancel' /> \
            </div> \
        </td> \
      </tr>");
    $.template("nested", "<option value='${id}'>${french}</option>");
    $(el).closest("tr").after($.tmpl(listTemplate, {results: categories}));
  },

  hideWidget: function() {
    this.element.find(".inline-picker").remove();
  },

  update: function(results) {
    this.redraw(results);
    this.hideWidget(this.element);
  },

  redraw: function(mapping) {
    var html = $.tmpl("<span data-id='${id}'>${name}<a class='inline-delete' href='x'>x</a></span>", mapping);
    var wrapper = this.parent.prev().find(".categories .inline-list");
    $(html).appendTo(wrapper);
  }
});