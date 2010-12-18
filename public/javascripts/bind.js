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