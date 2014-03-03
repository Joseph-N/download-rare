$(document).ready(function(){
	$("a[rel^='prettyPhoto']").prettyPhoto({
		deeplinking: false
	});

	$('#caroufredsel').carouFredSel({
		responsive: true,
		scroll : 4,
		circular: true,
		infinite: true,
		items: {
		  visible: {
		      min: 1,
		      max: 4
		  }
		},
		prev: '#portfolio-next',
		next: '#portfolio-prev',
		auto: {
		  play: false
		}
	});

	$(".gallery:first a[rel^='prettyPhoto']").prettyPhoto({
		slideshow:3000,
		autoplay_slideshow: true,
		deeplinking: false,
		overlay_gallery: false,
		show_title: false
	});

	// get imdb rating
	var imdb_id = $('#imdb-rating').attr('data-id');
	$.ajax({
	  url: "http://www.omdbapi.com/?i=" + imdb_id,
	  dataType: "JSON",
	  success: function(data){
	    $('#imdb-rating').text("IMDB Rating: " + data.imdbRating + " / 10");
	    $('div.raty').attr('data-score', data.imdbRating);
	  }
	});
});

$(window).load(function(){
	// set score with raty
	$('div.raty').raty({
		number: 10,
		readOnly: true,
		path: '/assets',
		score: function() {
			return $(this).attr('data-score');
		}
	});
})