$.Controller("PartnerPicker",
{
  init: function() {
    this.partners = [];
  },

  "select change": function(el) {
    $.get("/partners/" + $(el).val() + "/partner_categories", this.updateCategoryList.bind(this))
  },

  updateCategoryList: function(categories) {
    var list = this.element.find("tbody");
    list.empty();
    var template = "<tr><td><input type='checkbox' value='${partner_category.id}' name='s[category_id][]' /></td><td> ${partner_category.french}</td></tr>";
    $($.tmpl(template, categories)).appendTo(list);
  }
});