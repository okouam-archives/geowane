var PageNavigator = function(links) {

  this.links = links;

  this.hideAllSections = function() {
    for(var i = 0; i < links.length; i++) {
      $("div." + links[i]).hide();
    }
  };

  this.showSection = function(identifier) {
    $("div." + identifier).show();
  };

  for(var i = 0; i < links.length; i++) {
    var identifier = links[i];
    var link = $("ul.content-page-sidebar li a." + identifier);
    link.click(function(id) {
      return function() {
        this.hideAllSections();
        this.showSection(id)
      }.bind(this);
    }.bind(this)(identifier))
  }
};
