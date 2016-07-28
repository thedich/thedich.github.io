/*
 * #distinctive
 */

var onWheel = 
{ 		
		init: function(elemId, deltaMinus, deltaPlus) {
			  var elem = document.getElementById(elemId); 
			  if (elem.addEventListener) {
			  if ('onwheel' in document) { // IE9+, FF17+
				elem.addEventListener ("wheel", onWheel, false);
			  } else if ('onmousewheel' in document) { // устаревший вариант события
				elem.addEventListener ("mousewheel", onWheel, false);
			  } else { // 3.5 <= Firefox < 17, более старое событие DOMMouseScroll пропустим
				elem.addEventListener ("MozMousePixelScroll", onWheel, false);
			  }
			} else { // IE<9
			elem.attachEvent ("onmousewheel", onWheel);
			}

			function onWheel(e) {
			  e = e || window.event;
			  var delta = e.deltaY || e.detail || e.wheelDelta;
			  if(delta < 0) deltaMinus();
			  else deltaPlus();
			}
		}	
}		
