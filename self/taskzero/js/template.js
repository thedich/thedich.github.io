$(document).ready(function ()
{
	//$(window).resize(function(){ onresize();});
	$(function() { $( "#slider" ).slider(
		{
			value:400,
			min: 0,
			max: 500,
			step: 20,
			slide: function( event, ui ) {
				
				$( "#taskholder" ).width( 300 + ui.value );
				onresize();
			}
		}
	);});
	
	var content = $('#textholder').html();
	var biga = $('#biga').css('font-size').split('px')[0];
	var margin = 8;
	
	$('#textholder').css('margin-left', biga/2 + 'px');
	onresize();
	
	function onresize()
	{
		console.log('is resize!');
		var strA = content.split(' ');
		var resultA = []; var resA = []; var linen = 0;
	
		for ( var i in strA)
			if(fakeHolderAppend(resA.join(' '), linen))
				resA.push(strA[i])
			else { ;
					resA.pop();
					resultA.push(resA.join(' '));
					resA = []; resA.push(strA[i]);
					linen++;
				 };
		
		resultA.push(resA.join(' '));
		addToTextHolder(resultA);
	}
	
	function addToTextHolder(resultA)
	{
		$('#textholder').empty(); var res = '';
		for ( var ii in resultA) res += "<li style='padding-left:" + margin*Number(ii) +"px;'>" + resultA[ii] + "</li>";		
		
		$('#textholder').append('<ul>' + res + "</ul>");
	}
	
	function fakeHolderAppend(str, n)
	{
		var curmargin = $('#textholder').css('margin-left').split('px')[0];
		var newmargin = Number(curmargin) + n*margin;
		$('#textholder').css('margin-left', newmargin + 'px')
		
		$('#textholder').empty();
		$('#textholder').append(str);
		var fakeH = $('#textholder').height();
		var fonts = $('#textholder').css('font-size'); 
		var numlines = parseInt(fakeH/fonts.split('px')[0]);
		
		$('#textholder').css('margin-left', curmargin + 'px');
		if(numlines > 1) return false;
		
		return true;
		
	}
});