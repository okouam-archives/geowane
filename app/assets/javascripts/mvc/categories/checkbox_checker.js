$.Controller("CheckboxChecker",
{
  init: function() {
    this.isLandmark = $("#category_is_landmark");
    this.isHidden = $("#category_is_hidden");
    this.assertUniqueness(this.isHidden, this.isLandmark);
    this.assertUniqueness(this.isLandmark, this.isHidden);
  },

  "#category_is_landmark change": function(called) {
    this.assertUniqueness(called, this.isHidden);
  },

  "#category_is_hidden change": function(called) {
    this.assertUniqueness(called, this.isLandmark);
  },

  assertUniqueness: function(el, other) {
    if ($(el).is(":checked")) {
      other.removeAttr("checked");
      other.attr("disabled", "disabled");
    }
    else {
      other.removeAttr("disabled");
    }
  }
});