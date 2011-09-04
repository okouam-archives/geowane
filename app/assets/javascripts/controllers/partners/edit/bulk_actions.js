$.Controller("BulkActions",
{
 ".button click": function() {
   var action = this.getAction();
   if (this.isLabel(action)) return;
   var rows = this.getRows();
   if (rows.length < 1) {
      alert("Please select one or more categories to delete.");
   } else {
     var partner_id = $("tbody").data("partner-id");
     PartnerCategories.remove(this.getIds(rows), partner_id, function() {
      rows.remove();
     });
   }
  },

  getIds: function(rows) {
    return rows.map(function() {return $(this).data("id")}).get();
  },

  getRows: function() {
    return $("tbody tr").has(".selector input:checked");
  },

  getAction: function() {
    return this.element.find("select").val();
  },

  isLabel: function(el) {
   this.action = $(el).val();
   return this.action == "Bulk Actions";
  }
});