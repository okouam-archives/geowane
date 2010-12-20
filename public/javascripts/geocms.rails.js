String.prototype.underscore = function() {
  return this.replace(/^\s+|\s+$/g, '').replace(/\s/g, "_").toLowerCase();  
};
