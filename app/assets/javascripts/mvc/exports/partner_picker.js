$.Controller("PartnerPicker",
{
  init: function() {
    this.list = this.element.find("tbody");
    this.template = "<tr><td><input type='checkbox' value='${partner_category.id}' name='s[category_id][]' /></td><td> ${partner_category.french || '-'} / ${partner_category.english || '-'}</td></tr>";
  },

  "select change": function(el) {
    $.get("/partners/" + $(el).val() + "/partner_categories", this.updateCategoryList.bind(this))
  },

  updateCategoryList: function(categories) {
    this.list.empty();
    $($.tmpl(this.template, categories)).appendTo(this.list);
    this.list.find('tr:odd').css('background-color', '#fbfbfb');
  }
});