// Custom Javascript for driving jquery ui and bootstrap
// Written here instead of in app/assets with coffee because
// rails thinks it's funny to automatically surround everything
// in document.ready blocks and so screws up scoping

$.fx.speeds._defaults = 750;
var dialogOptions = { autoOpen: false,	show: "explode", hide: "explode" };
var register = function(tag) {
	$("#new-" + tag + "-dialog").dialog( dialogOptions ) ;
	$("#new-" + tag + "-button").click( function() {
		$("#new-" + tag + "-dialog").dialog( "open" );
		return false;
	} ); // click cb
	$("#close-" + tag + "-button").click( function() {
		$("#new-" + tag + "-dialog").dialog( "close" );
		return false;
	} );// click cb
}; // register

$(document).ready( function() {
	$("[rel=popover]").popover( ); // popover
	$("[rel=tooltip]").tooltip( ); // popover
} ); // document ready
