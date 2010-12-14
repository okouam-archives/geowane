$.fn.assertExists = function() {
  if (this.length == 0) throw new Error("Assertion failed: $('" + $(this).selector + "') did not return any elements");
  return this;
};

$.fn.shorten = function(sentence, charCount) {
  if (sentence.length < charCount) return sentence;
  return sentence.substring(0, charCount) + "..."
}

if (!String.prototype.startsWith){
    String.prototype.startsWith = function (str) {
        return !this.indexOf(str);
    }
}
