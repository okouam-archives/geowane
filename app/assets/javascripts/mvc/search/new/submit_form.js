$.Controller("SubmitForm",
{
  "form submit": function() {

    for (var i = 0; i < 5; i++) {
      var level = this.element.find("#level_" + i);
      if (level) level.attr("disabled", "disabled");
    }

    var boundary = $("#s_level_id");
    if (!boundary.val()) boundary.attr("disabled", "disabled");

    var localization_criteria = ["#s_city_id", "#s_radius", "#s_bbox"];
    this.filterUnused(localization_criteria);

    var categorization_criteria = ["#s_name", "#s_category_id"];
    this.filterUnused(categorization_criteria);

    var auditing_criteria = [
      "#s_added_by", "#s_corrected_by", "#s_invalidated_by",
      "#s_confirmed_by", "#s_audited_by", "#s_modified_by"
    ];
    this.filterUnused(auditing_criteria);

    var workflow_criteria = ["#s_added_on_before", "#s_added_on_after", "#s_status"];
    this.filterUnused(workflow_criteria);
  },

  filterUnused: function(criteria) {
    for (var i in criteria) {
      var element = $(criteria[i]);
      if (!element.val()) element.attr("disabled", "disabled");
    }
  }
});