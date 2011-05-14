var Location = Model("location", function() {
  this.include({
    save_coordinates: function() {
      $.ajax({
        url: "/locations",
        type: "PUT",
        data: {locations: [{id: this.id(), longitude: this.attributes.longitude, latitude: this.attributes.latitude}], commit: "Commit"},
        success: function() {
          alert("The coordinates have been successfully updated.");
        }
      });
    }
  });
});