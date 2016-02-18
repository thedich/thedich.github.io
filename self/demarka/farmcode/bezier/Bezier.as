package org.farmcode.bezier
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import org.farmcode.hoborg.IPoolable;
	import org.farmcode.hoborg.ObjectPool;
	import org.farmcode.math.Trigonometry;
	
	[Event(name="shapeChanged",type="au.com.thefarmdigital.events.BezierEvent")]
	public class Bezier extends EventDispatcher implements IPoolable
	{
		private static const SMALL_NUMBER:Number = 1e-29;
		private static const LENGTH_INTERVALS:Number = 0.01;
		
		private static const _drawPointPool:ObjectPool = new ObjectPool(DrawPoint);
		
		
		[Property(toString="true",clonable="true")]
		public function get start():BezierPoint{
			return _start;
		}
		public function set start(value:BezierPoint):void{
			if(value!=_start){
				if(_start){
					_start.removeEventListener(BezierEvent.POSITION_CHANGED, invalidateShape);
					_start.removeEventListener(BezierEvent.VECTOR_CHANGED, invalidateShape);
				}
				_start = value;
				if(_start){
					_start.addEventListener(BezierEvent.POSITION_CHANGED, invalidateShape);
					_start.addEventListener(BezierEvent.VECTOR_CHANGED, invalidateShape);
				}
				invalidateShape();
			}
		}
		[Property(toString="true",clonable="true")]
		public function get end():BezierPoint{
			return _end;
		}
		public function set end(value:BezierPoint):void{
			if(value!=_end){
				if(_end){
					_end.removeEventListener(BezierEvent.POSITION_CHANGED, invalidateShape);
					_end.removeEventListener(BezierEvent.VECTOR_CHANGED, invalidateShape);
				}
				_end = value;
				if(_end){
					_end.addEventListener(BezierEvent.POSITION_CHANGED, invalidateShape);
					_end.addEventListener(BezierEvent.VECTOR_CHANGED, invalidateShape);
				}
				invalidateShape();
			}
		}
		[Property(toString="true",clonable="true")]
		public function get tolerance():Number{
			return _tolerance;
		}
		public function set tolerance(value:Number):void{
			if(value!=_tolerance){
				_tolerance = value;
				invalidateShape();
			}
		}
		public function get length():Number{
			validateShape();
			return _length;
		}
		public function get straight():Boolean{
			validateShape();
			return _straight;
		}
		[Property(toString="true",clonable="true")]
		public function get dispatchEvents():Boolean{
			return _dispatchEvents;
		}
		public function set dispatchEvents(value:Boolean):void{
			_dispatchEvents = value;
		}
		
		private var _dispatchEvents:Boolean = true;
		private var _start:BezierPoint;
		private var _end:BezierPoint;
		private var _tolerance:Number;
		private var _length:Number;
		private var _straight:Boolean;
		private var _drawPoints:Array;
		private var invalidShape:Boolean = true;
		
		
		public function getLengthAt(fract:Number):Number{
			if(start && end){
				if(_straight){
					return distance(start.x,start.y,end.x,end.y)*fract;
				}else{
					var stack:Number = 0;
					var ret:Number = 0;
					var lastPoint:BezierPoint;
					do{
						stack += LENGTH_INTERVALS;
						var bezPoint:BezierPoint = getPointAt(stack,false);
						if(lastPoint){
							ret+= distance(bezPoint.x,bezPoint.y,lastPoint.x,lastPoint.y)*(1-Math.min(Math.max(stack-fract,0),1));
							lastPoint.release();
						}
						lastPoint = bezPoint;
					}while(stack<fract);
					bezPoint.release();
					return ret;
				}
			}else{
				return 0;
			}
		}
		public function getPointAt(fract:Number, includeVector:Boolean = true):BezierPoint{
			validateShape();
			if(start && end){
				var ret:BezierPoint = BezierPoint.getNew();
				ret.dispatchEvents = false;
				if(!_straight){
					ret.x = getAxisPosition(start.x, start.x+(start.forwardVector?start.forwardVector.x:0), end.x+(end.backwardVector?end.backwardVector.x:0), end.x, fract);
					ret.y = getAxisPosition(start.y, start.y+(start.forwardVector?start.forwardVector.y:0), end.y+(end.backwardVector?end.backwardVector.y:0), end.y, fract);
					if(includeVector){
						var vector:Point = new Point();
						vector.x = getAxisVector(start.x, start.x+(start.forwardVector?start.forwardVector.x:0), end.x+(end.backwardVector?end.backwardVector.x:0), end.x, fract);
						vector.y = getAxisVector(start.y, start.y+(start.forwardVector?start.forwardVector.y:0), end.y+(end.backwardVector?end.backwardVector.y:0), end.y, fract);
						ret.vector = vector;
					}
				}else{
					ret.x = start.x+((end.x-start.x)*fract);
					ret.y = start.y+((end.y-start.y)*fract);
					if(includeVector){
						ret.angle = Trigonometry.getAngleTo(start.toPoint(),end.toPoint());
						ret.distance = 1;
					}
				}
				ret.dispatchEvents = true;
				return ret;
			}else if(start){
				return start.clone() as BezierPoint;
			}else{
				return null;
			}
		}
		protected function getAxisPosition(c0:Number, c1:Number, c2:Number, c3:Number, fract:Number):Number{
			var ts:Number = fract*fract;
			var g:Number = 3 * (c1 - c0);
			var b:Number = (3 * (c2 - c1)) - g;
			var a:Number = c3 - c0 - b - g;
			return ( a*ts*fract + b*ts + g*fract + c0 );
		}
		protected function getAxisVector(c0:Number, c1:Number, c2:Number, c3:Number, fract:Number):Number{
			var g:Number = 3 * (c1 - c0);
			var b:Number = (3 * (c2 - c1)) - g;
			var a:Number = c3 - c0 - b - g;
			return ( 3*a*fract*fract + 2*b*fract + g );
		}
		
		public function drawInto(graphics:Graphics, moveTo:Boolean=true, offset:Point=null):void{
			validateShape();
			var l:int = _drawPoints.length;
			for(var i:int=0; i<l; ++i){
				var method:String = _drawPoints[i].method;
				if(method!="moveTo" || moveTo){
					var args:Array = _drawPoints[i].args.slice();
					if(offset){
						var xAxis:Boolean = true;
						for(var j:int=0; j<args.length; j++){
							args[j] = args[j]+(xAxis?offset.x:offset.y);
							xAxis = !xAxis;
						}
					}
					graphics[method].apply(null,args);
				}
			}
		}
		public function reset():void{
			_dispatchEvents = true;
			_start = null;
			_end = null;
			_tolerance = NaN;
			_length = NaN;
			_straight = false;
			_drawPoints = null;
			invalidShape = true;
		}
		private function doMidPointMethod (drawPoints:Array, start:Point, startControl:Point, endControl:Point, end:Point, tolerance:Number):void{
			var intersect:Point = intersect2Lines (start, startControl, endControl, end);
			var dx:Number = (start.x + end.x + intersect.x * 4 - (startControl.x + endControl.x) * 3) * .125;
			var dy:Number = (start.y + end.y + intersect.y * 4 - (startControl.y + endControl.y) * 3) * .125;
			if (dx*dx + dy*dy > tolerance) {
				var halves:Object = bezierSplit (start, startControl, endControl, end);
				doMidPointMethod(drawPoints, start, halves.first.startControl, halves.first.endControl, halves.first.end, tolerance);
				doMidPointMethod(drawPoints, halves.last.start,  halves.last.startControl, halves.last.endControl, end, tolerance);
			} else {
				var point:DrawPoint = _drawPointPool.takeObject();
				point.method = "curveTo";
				point.args = [intersect.x, intersect.y, end.x, end.y];
				drawPoints.push(point);
			}
		}
		private function bezierSplit(start:Point, startControl:Point, endControl:Point, end:Point):Object{
			var p01:Point = midLine(start, startControl);
			var p12:Point = midLine(startControl, endControl);
			var p23:Point = midLine(endControl, end);
			var p02:Point = midLine(p01, p12);
			var p13:Point = midLine(p12, p23);
			var p03:Point = midLine(p02, p13);
			return {
				first:{start:start,  startControl:p01, endControl:p02, end:p03},
				last:{start:p03, startControl:p13, endControl:p23, end:end }  
			}
		}
		private function midLine(a:Point, b:Point):Point{
			return new Point((a.x + b.x)/2, (a.y + b.y)/2 );
		}
		private function intersect2Lines(start:Point, startControl:Point, endControl:Point, end:Point):Point{
			var dx1:Number = startControl.x - start.x;
			var dx2:Number = endControl.x - end.x;
			
			var m1:Number = (startControl.y - start.y) / dx1;
			var m2:Number = (endControl.y - end.y) / dx2;
			
			if (!dx1 || !m1) {
				return new Point(start.x, m2 * (start.x - end.x) + end.y);
			} else if (!dx2 || !m2) {
				return new Point(end.x, m1 * (end.x - start.x) + start.y);
			}
			dx1 = dx1 || SMALL_NUMBER;
			dx2 = dx2 || SMALL_NUMBER;
			m1 = m1 || SMALL_NUMBER;
			m2 = m2 || SMALL_NUMBER;
			var xInt:Number = (-m2 * end.x + end.y + m1 * start.x - start.y) / (m1 - m2);
			var yInt:Number = m1 * (xInt - start.x) + start.y;
			return new Point(xInt, yInt);
		}
		
		protected function invalidateShape(e:Event=null):void{
			invalidShape = true;
			if(_dispatchEvents){
				dispatchEvent(new BezierEvent(BezierEvent.SHAPE_CHANGED));
			}
		}
		protected function validateShape():void{
			if(invalidShape){
				var point:DrawPoint;
				var wasDispatching:Boolean = _dispatchEvents;
				_dispatchEvents = false;
				for each(point in _drawPoints){
					_drawPointPool.releaseObject(point);
				}
				invalidShape = false;
				_drawPoints = [];
				if(start && end){
					point = _drawPointPool.takeObject();
					point.method = "moveTo";
					point.args = [start.x,start.y];
					_drawPoints.push(point);
					_straight = testStraight();
					if(!_straight){
						var stPoint:Point = start.toPoint();
						var edPoint:Point = end.toPoint();
						doMidPointMethod(_drawPoints,stPoint, start.forwardVector?start.add(start.forwardVector):stPoint, end.backwardVector?end.add(end.backwardVector):edPoint, edPoint, tolerance*tolerance);
					}else{
						point = _drawPointPool.takeObject();
						point.method = "lineTo";
						point.args = [end.x,end.y];
						_drawPoints.push(point);
					}
				}
				_length = getLengthAt(1);
				_dispatchEvents = wasDispatching;
			}
		}
		protected function testStraight():Boolean{
			if((start.forwardVector && start.forwardVector.length) || (end.backwardVector && end.backwardVector.length)){
				var slope:Number = (end.x-start.x)/(end.y-start.y);
				if(start.forwardVector && start.forwardVector.length && (start.forwardVector.x)/(start.forwardVector.y)!=slope){
					return false;
				}
				if(end.backwardVector && end.backwardVector.length && -(end.backwardVector.x)/(end.backwardVector.y)!=slope){
					return false;
				}
			}
			return true;
		}
		public function getFractClosestTo(point:Point, tolerance:Number = 0.05):Distance{
			validateShape();
			if(_straight){
				return getFractClosestToStraight(point);
			}else{
				return getFractClosestToCurved(point,tolerance);
			}
		}
		/*
		This may not be the cleanest way to do this, but it may be the fastest, will look into it.
		*/
		protected function getFractClosestToCurved(point:Point, tolerance:Number):Distance {
			var nearest:Distance = new Distance();
			var startFract:Number = 0;
			var endFract:Number = 1;
			
			if(start && end){
				var start:Point = start.toPoint();
				var end:Point = end.toPoint();
				var startDist:Number = Trigonometry.getDistance(start,point);
				var endDist:Number = Trigonometry.getDistance(end,point);
				while(endFract-startFract>tolerance){
					var midFract:Number = startFract+((endFract-startFract)/2);
					var bezMid:BezierPoint = getPointAt(midFract);
					var mid:Point = bezMid.toPoint();
					bezMid.release();
					var midDist:Number = Trigonometry.getDistance(mid,point);
					
					if(isNaN(nearest.distance) || nearest.distance>midDist){
						nearest.distance = midDist;
						nearest.fract = midFract;
					}
					var _startDist:Number = startDist;
					var _endDist:Number = endDist;
					if(startDist==endDist){
						_startDist = Trigonometry.getDistance(mid,start);
						_endDist = Trigonometry.getDistance(mid,end);
					}
					if(_startDist<_endDist){
						endFract = midFract;
						end = mid;
						endDist = midDist
					}else{
						startFract = midFract;
						start = mid;
						startDist = midDist
					}
				}
				return nearest;
			}else{
				return null;
			}
		}
		protected function getFractClosestToStraight(point:Point):Distance {
			var ret:Distance = new Distance();
			
			var d1:int = end.x - start.x; // run
			var d2:int = end.y - start.y; // rise
			
			// (v1, v2) is the vector from end point 1 of segment to point
			var v1:int = point.x - start.x;
			var v2:int = point.y - start.y;
		 
			// the dot product between (d1,d2) and (v1, v2)
			var t:int = dotProduct(d1, d2, v1, v2);
			var dLengthSquared:int = dotProduct(d1, d2, d1, d2);;
		 
			if(t <= 0) {
				ret.fract = 0;
				ret.distance = Math.sqrt(dotProduct(v1, v2, v1, v2));
			} else if(t >= dLengthSquared) {
				ret.fract = 1;
				var u1:int = point.x - end.x;
				var u2:int = point.y - end.y;
				ret.distance = Math.sqrt(dotProduct(u1, u2, u1, u2));
			} else {
				ret.fract = t/dLengthSquared;
				ret.distance = Math.sqrt(dotProduct(v1, v2, v1, v2) - (t*t)/dLengthSquared);
			}
			return ret;
		}
		
		// simple maths functions
		protected function distance(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			return Math.sqrt(((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1)));
		}
		protected function dotProduct(x1:Number, y1:Number, x2:Number, y2:Number):Number{
			return (x1*x2) + (y1*y2);
		}
	}
}

/*

:::://+sydmmmmmmdddddhhhhhhddhhdhhhdhyydmmdhdmmddmdNmhhyo/.````-``              
::::::/+sydmmmmdddddddhhhdmmNNNmddddhdmmmmmddNNNmNNNNNNmmddy+++yo-::.```     ```
:::::::/+sdmmmmmmddmdmmmdddmNNNNmmNNNmNmNNNNNNNNNNNNNNNNmNNdNNNmo:-.//.```````.`
::::::::/+syhhdhhdhmdNNNmNmNNNMMMMMMMMMNdhNMMMMMNNNNNNMMNmddmNNmy/..-+..`` `````
:--:::--:/+ydhdhdhmNNMNNNNNMNMMMMMMMMMMmdmMMMMMmhmNNNNNNNNmdmNNNNdyshs--/-..````
:-------::oyyhmNNNNNMMNmmMMMNNNMMMMMMMMMMNMMMMMNNyMmhmMMNNmmmNNMMMMNMNhhdhys+/.`
:-------:+yyhhmMMMMNMMNMMMMMMNdMMMMMMMMMMMMMMMMMMNNydNNNmmMNhhNMMMMNNNNmdyhdmy:`
--------:oyhmmMMMMMNMMMMMMMMMMNMMMMNmmMMMMMMMMMMMMmhhmmhdNNNmhNMMMMMMNNmddmdhNs`
.--::-:::/syNdymNMMMMMNNNMMMMmNNMMMMNNMMMMMMMMMMMMMNmyhmNNNmdNMMMMMMMMMMNmNNmmh/
.:----oohdmmNNmNMMMMMMMMMMMMMNNmMMMMNMMMMMMMMMmmNMMMNsdhMNNmmMMMMMMMMMMMNNmmmmmN
`::--/hdmNMNMMMMMMMNMMMMMMMNMMMMMNMMMMMMNMMMMNNNNNNMMdshmNNmMMMMMMMMMMNNMMNNNNNM
`:/:+smNmmmNMNMNNmNNmMMMMMMMMMMMMNNMNNNNNNNNNNNMMMNMMNNmdMNmMMMMMMMMMMNmNMMNNNMM
`-///yNNmmNMMNNNNmNNNNMMMMMMNMNNmydhssyo///shdmmNNNNMMMMNMMNMMNMMMMMMMNNNNMMMMNM
`./+sdNNNNMMNNmNmMMMMNNNMNMNNNmdo++/:--//+osoyydmNNNNMMMMMNMMMMMMMMMMMNNNNNMMMNM
``/ooymMMMMMNNNNNMMMMmsyddhhmddo:---::--:+o+odmNmmmdmmNMMMMMMMMMMMNNNmmNNNNNMNmN
`.oyhdNNMMMMMMMNNNMMmmyo+o+oo+-....-----:://oyyyhhddddmNNNMMMMMMMNNMNmmMMMNNNNmd
./yddhNNNNMMMMMMMMMmNdoys+::......---...---:/+oyhhhdddhdmNNMMNMMMNMNMMMMMMMMMNNN
.odhmmdhmNMMMMMMMMmyy+:o/..```.....--...-/++oosyhhddddddmmNNmNNNNNNMMMMMMMMNNNNm
`oNNNNNNMMNMMMMMNmy+/:+-````...-----.``--:/++sssyhdddddmmmdNNNMNNNMmMMNNMMMMNNNN
`+mNNNMMMMMMMMMMNd++:-.````...------`.-::://+osssyhdhddmmmmNmNNMMMNNMMMMMMMNNMMN
`omNMMMNNNNMMMNNNdo+//:::----.--::..--.:/+oosshddmddhdhdmmNNNNNNMMMMMMMMMNMMMMMN
`:ymMMMMMMMMMMMNdhhysoyhhhyso+//++-::-/syhmmmmNNNNNmmdhyhmmNNMNmNNMMMMMMMMMMMMNm
``.+dMMMMMMMMMMNydyssoymNNNNmdhoso:/+ydmNMMMMMMMMNMNNNNmdmmNNNNNNMNMMMMMMMMMNNNN
```.yNNNNNMMMMMNoo/+shdmNNNNmdhs+/:+hNMMMMMMMNNNNNNNNNNNNmmmNNNMMMMMMMMMMMNMNMNN
``.-ymNMMMMMMMMM++omNNNmmsymmmds-.:oNMMMMMMMNNh+yNMMMNMMNNmdhhdmMMMMMMMMMMMMMMMM
...:dmNNMMMMMMMN//+ydymdh::osooo-./yNMMMNMNmdmdosddddNmNNmdys+shNMMMMMMMMMMMMMMM
-..-:ohNMMMMMMMN/--:/osoo+sys+:...:sdNMNNNdooyyhmmmhsssdmdyo++sdmNMMMMMMMMMMMMMM
:--.-/++yNMMMMMN/-...:syhddhs+:-..:++dNNNNNmyhdNNNmdhsshhyyo//+symMMMNNMMMMMMMMM
y/:--:+::/ohmNNNo:-...--:/+/:..-.-:+.:sdNNNNNNmmmmddhyysssso/://+yNNNmdMMNNNMMMM
ms+:::+/:::::++oy/:--.--::-.`.-:.-/o...:smNmmmNmhsssyyyyysso//:::sNMNddmhyyNMMMM
Nho+/:+o/:::...-y+/:-....```.-::.-++-.../hmmmmmdhsosyhhhyyso+//::/hyyyhy:/dMMMMM
dyso+/+o+//:-../Mh+::-......-:/:.-+s-..//dNNNNNmddyyhhhhhyyo++//::-.o+/:/sMMMMNM
dhyso++so+///-.:mmo+/::----:+/:/.-oy:-:o++mMMMNNNmddddhhhhyss++//:-:mysymMMMMMNM
Nmdyoo+so+++/:-.-soo+/::::+ss/::.:+ys:++++yMMMMMNNNmmdhhhhhyso+/:::yMMMMMNNNdyyd
MMmyooosso+++/-..`.oo+///+yy//++oyhmmdmNMMMNNNMMMMMNNmhyhhhyso+//:/NMMMMNNd+-``-
MMmhsooosooo++/-...+so+/+sy::/+ohdNMMMMMMMMMMMMMMMMMNNdhyyhysso++/oMMMMMMm-`````
MMmhso+ossoooo+:---:ssooos+:/+oosyNMNmNNNNMMMMMMMMMMMNmmhhhyyyso++dMMMMMN:``````
MMNhso++sssooo+::::::ssooo+++oossshNhsmNNNNMMMMMMMNNNNmmddhysssooshNMMMNs.``````
MMMmyso+sysooo///:-.`/ysoooyhysyysoyssmNMMMMMMMMMNdymmmmmddhyyysyyymMMMh:.``````
MMMNdysooyysooo//-...:hyssymNmhhhhddmdmNNNNMMMMMMMmhNNmmmmdhhyyhysyNMMMm+.``````
MMMMmhysshhysso+-...-hMdyyhddyss+++osoyhdmNMMMMMMNmmNNNNNmddhhyyssNMMMMNs:`````.
MMMMNmdhhmmmdy+-..../mMMmhhhhyyyhdmNNNMMMMMMMMMMMNNNMNNNNmmdhhysymMMMNMNy/.````.
NNMMmdddmNMNm+.`....oNMMMNdhyssshddddmmmmNNNNNNmmNNNNNmmmmdyyysyNMMMNNMNy/.````.
yhdhysosydNh-``.....oNMMMMMmyysoso+///+ooyddhhddmNNNmmmNNmhyyshNMMMNNmNNs:.````.
://///:/+o/.`.......oNMMMMMMhyso++o/+oosyhddddddmdmmmmNNmhyssdMMMMMNmdNm+-.```..
-:::///+:..........-sNMMMMMMNhyysyyyhhhdmmNmNNNNmdmmNNNmdyssmMMMMMNNmdNh+-......
+++oooo:...........-ymNMMMMMmsyhhhdmmmmNNNMMMMMNNNMMNNdhyyymMMMMMMNmmdms/-......
hyyyys:............-smNNMMMMmooyyyyhhddmmNNNMMMMMMMNmdhhhdNNMMMMMNNmmmho/-......
yyyys:............./dmNNMMMMm++oooooososoyhhhdmMMMNmdddmNNNNNNNNNNNmmds+--......

**/