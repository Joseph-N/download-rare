(function($) {
	$(document).ready(function() {

		$( '#s' ).each( function(){
		$(this).attr( 'name', $(this).val() )
		  .focus( function(){
			if ( $(this).val() == $(this).attr('name') ) {
			  $(this).val( '' );
			}
		  } ).blur( function(){
			if ( $(this).val() == '' || $(this).val() == ' ' ) {
			  $(this).val( $(this).attr('name') );
			}
		  } );
		} );

		$('input#s').result(function(event, data, formatted) {
			$('#result').html( !data ? "No match!" : "Selected: " + formatted);
		}).blur(function(){		
		});
		
		$(function() {		
		function format(resource) {
			return "<a href='"+resource.permalink+"'><img src='" + resource.image + "' /><span class='title'>" + resource.name +"</span><br> <span class='label label-default'>"+ resource.type +"</span></a>";			
		}
		
		function link(resource) {
			return resource.permalink
		}

		function name(resource) {
			return resource.name
		}
		
		$("#s").autocomplete('/movies', {
			width: $("#s").outerWidth()-2,			
			max: 5,			
			scroll: false,
			dataType: "json",
			matchContains: "word",
			parse: function(data) {
				return $.map(data, function(row) {
					return {
						data: row,
						value: row.name,
						result: $("#s").val()
					}
				});
			},
			formatItem: function(item) {				
				return format(item);
			}
			}).result(function(e, item) {
				$("#s").val(name(item));
				location.href = link(item);
			});						
		});
				
	});
})(jQuery);