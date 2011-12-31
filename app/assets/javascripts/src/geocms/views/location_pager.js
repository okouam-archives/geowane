GeoCMS.Views.LocationPager = Backbone.View.extend({

  initialize: function() {
    $("#pages").val($.App.Search.pageSize);
    $("#pages").change(function() {
      $.App.Search.set({pageSize: $(this).val(), page: 1});
    });
  },

  render: function() {
    if ($.App.Search.total > 0) {
      this.renderPageSizeControl();
      this.renderPageNavigator();
      this.renderCounter($.App.Search.total, $.App.Search.page, $.App.Search.pageSize)
    }
  },

  renderCounter: function(total, page, pageSize) {
    var lower = page > 1 ? page * pageSize : page;
    var upper = total > pageSize ? lower + pageSize : total;
    var html = "<span id='pagination-counter'><b>" + lower + "&nbsp;-&nbsp;" + upper + "</b> of <b>" + total + "</b></span><div class='clear'></div><div class='clear'></div>"
    $(this.el).append(html);
  }
});