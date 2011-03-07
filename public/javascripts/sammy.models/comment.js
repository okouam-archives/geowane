var Comment = Model("comment", function() {
  this.extend({
    find_by_location_id: function(location_id) {
      return this.select(function() {
        return this.attr("location_id") == parseInt(location_id)
      })
    }
  });
  this.include({
    to_hash: function() {
      return {user: this.attr("user"), text: this.attr("text"), created_at: this.attr("created_at")};
    }
  });
});