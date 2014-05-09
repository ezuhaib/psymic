// Most js libraries are kept in vendors directory and are being used
// without help of gems. So any updates will have to be done manually.
// This shouldn't be an issue, except for bootstrap, because it's gem
// is still being used for sass assets, but not for js because we are
// using a minified version. Although bootstrap is currently locked at
// 3.1.1 ... in case it is decided to update it, the minified js should
// also be updated.
//
//
//= require jquery.min
//= require jquery_ujs
//= require turbolinks
//= require jquery.sidr.min
//= require bootstrap.min
//= require bootstrap-select.min
//= require jquery.autosize.min
//= require_tree ../../../vendor/assets/javascripts/noty
//= require_tree ./application