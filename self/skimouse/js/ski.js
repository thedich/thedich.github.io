window.onload = function(){
	var draw = document.getElementById("draw");
	draw.width = 400;
	draw.height = 400;
	var ctx = draw.getContext("2d");
	ctx.fillStyle = "#FF0000";
	ctx.width = 400;
	ctx.height = 400;
			
			
	//ctx.translate(0, -1);
	//ctx.fillRect(100, draw.height, 75, 10);
	//var dataImage = ctx.getImageData( 0, 0, ctx.width, ctx.height );
	//ctx.putImageData(dataImage, 0, 0);
	//ctx.translate(0, -1);
			
	function inRad(num) {return num * Math.PI / 180;}
			
			
	//ctx.translate(rectX, rectY);
	ctx.fillRect(100, draw.height, 75, 1);
	//ctx.translate(0, -1);
			
	ctx.fillRect(100, draw.height, 75, 1);
	var dataImage = ctx.getImageData( 0, 0, ctx.width, ctx.height );
	ctx.putImageData(dataImage, 0, 1);
	ctx.translate(0, -1);
			
	var colors = ["#FF0000", "#000"]
	var i = 0;	
	d3.timer(function() {
		var dx = Math.random()*10;
		var pm = Math.random() > .5 ? -1: 1;
				
		if(i <10) ctx.fillStyle = colors[1];
		else ctx.fillStyle = colors[0];
				
				
		//ctx.rotate(inRad( 1));
		ctx.fillRect(100, draw.height, 75, 1);
		var dataImage = ctx.getImageData( 0, 0, ctx.width, ctx.height );
		ctx.putImageData(dataImage, 0, 1);
		ctx.translate(0, -1);
					
		//var dataImage = ctx.getImageData( 0, 0, ctx.width, ctx.height );
		//ctx.drawImage(dataImage.data, 0, 0);
		//ctx.putImageData(dataImage,0,0);
		//ctx.translate(0, i);
		//ctx.fillRect(0,0,75,1);	
		i++;
		console.log("tranclate" + draw.width);
	});
};

