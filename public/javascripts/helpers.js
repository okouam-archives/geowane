$.fn.assertExists = function() {
  if (this.length == 0) throw new Error("Assertion failed: $('" + $(this).selector + "') did not return any elements");
  return this;
};

$.fn.shorten = function(sentence, charCount) {
  if (sentence.length < charCount) return sentence;
  return sentence.substring(0, charCount) + "..."
};

if (!String.prototype.startsWith){
    String.prototype.startsWith = function (str) {
        return !this.indexOf(str);
    }
}

String.prototype.underscore = function() {
  return this.replace(/^\s+|\s+$/g, '').replace(/\s/g, "_").toLowerCase();
};

(function(){
  var initializing = false, fnTest = /xyz/.test(function(){xyz;}) ? /\b_super\b/ : /.*/;

  // The base Class implementation (does nothing)
  this.Class = function(){};

  // Create a new Class that inherits from this class
  Class.extend = function(prop) {
    var _super = this.prototype;

    // Instantiate a base class (but only create the instance,
    // don't run the init constructor)
    initializing = true;
    var prototype = new this();
    initializing = false;

    // Copy the properties over onto the new prototype
    for (var name in prop) {
      // Check if we're overwriting an existing function
      prototype[name] = typeof prop[name] == "function" &&
        typeof _super[name] == "function" && fnTest.test(prop[name]) ?
        (function(name, fn){
          return function() {
            var tmp = this._super;

            // Add a new ._super() method that is the same method
            // but on the super-class
            this._super = _super[name];

            // The method only need to be bound temporarily, so we
            // remove it when we're done executing
            var ret = fn.apply(this, arguments);
            this._super = tmp;

            return ret;
          };
        })(name, prop[name]) :
        prop[name];
    }

    // The dummy class constructor
    function Class() {
      // All construction is actually done in the init method
      if ( !initializing && this.init )
        this.init.apply(this, arguments);
    }

    // Populate our constructed prototype object
    Class.prototype = prototype;

    // Enforce the constructor to be what we expect
    Class.constructor = Class;

    // And make this class extendable
    Class.extend = arguments.callee;

    return Class;
  };
})();

// http://www.brockman.se/writing/method-references.html.utf8
(function () {
     function toArray(pseudoArray) {
         var result = [];
         for (var i = 0; i < pseudoArray.length; i++)
             result.push(pseudoArray[i]);
         return result;
     }

     Function.prototype.bind = function (object) {
         var method = this;
         var oldArguments = toArray(arguments).slice(1);
         return function () {
             var newArguments = toArray(arguments);
             return method.apply(object, oldArguments.concat(newArguments));
         };
     }

     Function.prototype.bindEventListener = function (object) {
         var method = this;
         var oldArguments = toArray(arguments).slice(1);
         return function (event) {
             return method.apply(object, [event || window.event].concat(oldArguments));
         };
     }
})();