$.Controller("EditInformation",
{
  init : function(el, options){
    this.location_id = options.location_id;
  },
  "a:contains('Save') click" : function() {
    var loading = this.element.find(".portlet-content").busyBox({spinner: '<img src="/assets/images/ajax-loader.gif" />'});
    $.ajax({
      type: 'POST',
      dataType: 'json',
      url: "/locations/" + this.location_id,
      data: this.element.find("form").formParams(),
      success: function() {
        loading.busyBox('close');
      }
    });
    return false;
  }
});