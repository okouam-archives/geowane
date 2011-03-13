var Location = Model("location", function() {
  this.include({
    save_coordinates: function() {
      return null;
    }
  });
});