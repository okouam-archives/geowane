GeoCMS.Views.Lightbox.InfoEditor = Backbone.View.extend({

  initialize: function(options) {
    options.location.info.bind("change", this.render, this);
    var country = "#{@location.administrative_unit(0).try(:name)}";
    switch(country) {
      case "Côte d'Ivoire":
        jQuery.validator.addMethod("validPhoneNumber", function(value, element) {
          value = jQuery.trim(value);
          return value == "" || value.match(/^\+225 \d{2} \d{2} \d{2} \d{2}$/);
        }, "Not a valid Côte d'Ivoire phone number. It should be of the form +225 XX XX XX XX");
        break;
      case "Bénin":
        jQuery.validator.addMethod("validPhoneNumber", function(value, element) {
          value = jQuery.trim(value);
          return value == "" || value.match(/^\+229 \d{2} \d{2} \d{2} \d{2}$/);
        }, "Not a valid Bénin phone number. It should be of the form +229 XX XX XX XX");
        break;
      case "Sénégal":
        jQuery.validator.addMethod("validPhoneNumber", function(value, element) {
          value = jQuery.trim(value);
          return value == "" || value.match(/^\+221 \d{2} \d{3} \d{4}$/);
        }, "Not a valid Sénégal phone number. It should be of the form +221 XX XXX XXXX");
        break;
      case "Togo":
        jQuery.validator.addMethod("validPhoneNumber", function(value, element) {
          value = jQuery.trim(value);
          return value == "" || value.match(/^\+228 \d{3} \d{4}$/);
        }, "Not a valid Togo phone number. It should be of the form +228 XXX XXXX");
        break;
      case "Guinée":
        jQuery.validator.addMethod("validPhoneNumber", function(value, element) {
          value = jQuery.trim(value);
          return value == "" || value.match(/^\+224 \d{2} \d{2} \d{2}$/);
        }, "Not a valid Guinée phone number. It should be of the form +224 XX XX XX");
        break;
      default:
        jQuery.validator.addMethod("validPhoneNumber", function(value, element) {
          return true;
        }, "");
    }

    $("form.location").validate({
      debug: true,
      rules: {
        "location[email]": {
          email: true
        },
        "location[telephone]": {
          validPhoneNumber: true
        },
        "location[website]": {
          url: true
        }
      }
    });

    $(document).on("click", "#facebox #info .actions .blue-button", this.save.bind(this));
  },

  associate: function(location) {
    if (this.location) this.location.info.unbind("change", this.render);
    this.location = location;
    this.location.info.unbind("change", this.render);
    this.location.info.bind("change", this.render, this);
  },

  render: function(model) {

    $("#long_name").val(model.get("long_name"));
    $("#email").val(model.get("email"));
    $("#telephone").val(model.get("telephone"));
    $("#fax").val(model.get("fax"));
    $("#website").val(model.get("website"));
    $("#postal_address").val(model.get("postal_address"));
    $("#geographical_address").val(model.get("geographical_address"));
    $("#opening_hours").val(model.get("opening_hours"));
    $("#user_rating").val(model.get("user_rating"));
    $("#acronym").val(model.get("acronym"));
    $("#miscellaneous").val(model.get("miscellaneous"));

    this.wrapper().find("input").bind('input', function() {
      $("#" + this.el.id).find(".warning").html("The location has been modified. Click 'Accept' to keep changes.").show();
    }.bind(this));
  },

  wrapper: function() {
    return $("#" + this.el.id);
  },

  save: function() {
    var tab = $("#" + this.el.id);
    tab.find(".warning").hide();
    var $inputs = tab.find('form input');
    var values = {};
    $inputs.each(function() {
      values[this.name] = $(this).val();
    });
    $.ajax({
      type: "PUT",
      url: "/locations/" + this.location.id,
      data: {location: values}
    });
    return false;
  }

});

