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