
GeoCMS.Views.LocationPager = Backbone.View.extend({

  initialize: function(options) {
    var collection = options.locations;
    this.criteria = criteria = collection.criteria;
    $("#pages").val(criteria.pageSize);
    $("#pages").change(function() {
      criteria.set({pageSize: $(this).val(), page: 1});
    });
    collection.bind("reset", this.render, this);
  },

  render: function() {
    if (this.criteria.get("total_entries") > 0) {
      this.renderPageSizeControl();
      this.renderPageNavigator();
      this.renderCounter(this.criteria.get("total_entries"), this.criteria.get("page"), this.criteria.get("per_page"));
    }
  },

  renderPageNavigator: function() {
    var self = this;
    $("#paggination").pagination(this.criteria.get("total_entries"), {
      items_per_page: this.criteria.get("per_page"),
      current_page: this.criteria.get("page"),
      callback: function(page) {
        self.criteria.changePage(page);
        return false;
      }
	  });
  },

  renderPageSizeControl: function() {

  },

  renderCounter: function(total, page, pageSize) {
    var lower = ((page - 1) * pageSize) + 1;
    var upper = total > pageSize ? (page * pageSize > total ? total : page * pageSize) : total;
    var html = "<b>" + lower + "&nbsp;-&nbsp;" + upper + "</b> of <b>" + total + "</b>";
    $("#pagination-counter").html(html);
  }
});