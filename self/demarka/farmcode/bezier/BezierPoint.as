package org.farmcode.bezier
{
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	
	import org.farmcode.hoborg.IPoolable;
	import org.farmcode.hoborg.ObjectPool;
	import org.farmcode.math.Trigonometry;
	
	[Event(name="positionChanged",type="au.com.thefarmdigital.events.BezierEvent")]
	[Event(name="vectorChanged",type="au.com.thefarmdigital.events.BezierEvent")]
	public class BezierPoint extends EventDispatcher implements IPoolable
	{
		private static const pool:ObjectPool = new ObjectPool(BezierPoint);
		public static function getNew():BezierPoint{
			return pool.takeObject();
		}
		
		[Property(toString="true",clonable="true")]
		public function get x():Number{
			return _x;
		}
		public function set x(value:Number):void{
			if(value!=_x){
				_x = value;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.POSITION_CHANGED));
				}
			}
		}
		[Property(toString="true",clonable="true")]
		public function get y():Number{
			return _y;
		}
		public function set y(value:Number):void{
			if(value!=_y){
				_y = value;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.POSITION_CHANGED));
				}
			}
		}
		public function get backwardAngle():Number{
			if(_numbersInvalid)validateNumbers();
			return _backwardAngle;
		}
		public function set backwardAngle(value:Number):void{
			if(_numbersInvalid)validateNumbers();
			if(value!=_backwardAngle){
				_backwardAngle = value;
				_pointsInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		public function get backwardDistance():Number{
			if(_numbersInvalid)validateNumbers();
			return _backwardDistance;
		}
		public function set backwardDistance(value:Number):void{
			if(_numbersInvalid)validateNumbers();
			value = Math.abs(value);
			if(value!=_backwardDistance){
				_backwardDistance = value;
				_pointsInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		public function get forwardAngle():Number{
			if(_numbersInvalid)validateNumbers();
			return _forwardAngle;
		}
		public function set forwardAngle(value:Number):void{
			if(_numbersInvalid)validateNumbers();
			if(value!=_forwardAngle){
				_forwardAngle = value;
				_pointsInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		public function get forwardDistance():Number{
			if(_numbersInvalid)validateNumbers();
			return _forwardDistance;
		}
		public function set forwardDistance(value:Number):void{
			if(_numbersInvalid)validateNumbers();
			value = Math.abs(value);
			if(value!=_forwardDistance){
				_forwardDistance = value;
				_pointsInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		public function get angle():Number{
			if(_numbersInvalid)validateNumbers();
			return (_backwardAngle==(_forwardAngle+180)%360?_forwardAngle:NaN);
		}
		public function set angle(value:Number):void{
			if(_numbersInvalid)validateNumbers();
			if(value!=angle){
				_backwardAngle = (value+180)%360;
				_forwardAngle = value;
				_pointsInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		public function get distance():Number{
			if(_numbersInvalid)validateNumbers();
			return (_backwardDistance==_forwardDistance?_backwardDistance:NaN);
		}
		public function set distance(value:Number):void{
			if(_numbersInvalid)validateNumbers();
			value = Math.abs(value);
			if(value!=distance){
				_backwardDistance = _forwardDistance = value;
				_pointsInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		[Property(toString="true",clonable="true")]
		public function get forwardVector():Point{
			if(_pointsInvalid)validatePoints();
			return _forwardVector;
		}
		public function set forwardVector(value:Point):void{
			if(_pointsInvalid)validatePoints();
			if((!_forwardVector && value) || (_forwardVector && (!value || !_forwardVector.equals(value)))){
				_forwardVector = value;
				_numbersInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		[Property(toString="true",clonable="true")]
		public function get backwardVector():Point{
			if(_pointsInvalid)validatePoints();
			return _backwardVector;
		}
		public function set backwardVector(value:Point):void{
			if(_pointsInvalid)validatePoints();
			if((!_backwardVector && value) || (_backwardVector && (!value || !_backwardVector.equals(value)))){
				_backwardVector = value;
				_numbersInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		public function get vector():Point{
			if(_pointsInvalid)validatePoints();
			if(_backwardVector && _forwardVector){
				var back:Point = new Point(x-(_backwardVector.x-x),y-(_backwardVector.y-y));
				return back.equals(_forwardVector)?back:null;
			}else{
				return null;
			}
		}
		public function set vector(value:Point):void{
			if(_pointsInvalid)validatePoints();
			if((!vector && value) || (vector && (!value || !vector.equals(value)))){
				_forwardVector = value;
				_backwardVector = new Point(x-(value.x-x),y-(value.y-y));
				_numbersInvalid = true;
				if(_dispatchEvents){
					dispatchEvent(new BezierEvent(BezierEvent.VECTOR_CHANGED));
				}
			}
		}
		[Property(toString="true",clonable="true")]
		public function get dispatchEvents():Boolean{
			return _dispatchEvents;
		}
		public function set dispatchEvents(value:Boolean):void{
			_dispatchEvents = value;
		}
		
		private var _dispatchEvents:Boolean = false;
		private var _x:Number;
		private var _y:Number;
		
		private var _backwardAngle:Number;
		private var _backwardDistance:Number;
		private var _forwardAngle:Number;
		private var _forwardDistance:Number;
		
		private var _forwardVector:Point;
		private var _backwardVector:Point;
		private var _bothVector:Point;
		
		private var _pointsInvalid:Boolean = true;
		private var _numbersInvalid:Boolean = false;
		
		public function BezierPoint(x:Number=0, y:Number=0, angle:Number=NaN, distance:Number=NaN){
			this.x = x;
			this.y = y;
			this.angle = angle;
			this.distance = distance;
			_dispatchEvents = true;
		}
		public function validateNumbers():void{
			var thisPoint:Point = new Point(x,y);
			if(_backwardVector){
				_backwardAngle = Trigonometry.getAngleTo(thisPoint,_backwardVector);
				_backwardDistance = Trigonometry.getDirection(thisPoint,_backwardVector);
			}else{
				_backwardAngle = _backwardDistance = NaN;
			}
			if(_forwardVector){
				_forwardAngle = Trigonometry.getAngleTo(thisPoint,_forwardVector);
				_forwardDistance = Trigonometry.getDirection(thisPoint,_forwardVector);
			}else{
				_forwardAngle = _forwardDistance = NaN;
			}
			_numbersInvalid = false;
		}
		public function validatePoints():void{
			if(!isNaN(_forwardDistance) && !isNaN(_forwardAngle))_forwardVector = Trigonometry.projectPoint(_forwardDistance,_forwardAngle,new Point(0,0));
			else _forwardVector = null;
			if(!isNaN(_backwardDistance) && !isNaN(_backwardAngle))_backwardVector = Trigonometry.projectPoint(_backwardDistance,_backwardAngle,new Point(0,0));
			else _backwardVector = null;
			_pointsInvalid = false;
		}
		public function clone():BezierPoint{
			var ret:BezierPoint = BezierPoint.getNew();
			ret.x = x;
			ret.y = y;
			if(!_pointsInvalid){
				ret.forwardVector = _forwardVector;
				ret.backwardVector = _backwardVector;
			}else{
				ret.forwardAngle = forwardAngle;
				ret.forwardDistance = forwardDistance;
				ret.backwardAngle = backwardAngle;
				ret.backwardDistance = backwardDistance;
			}
			return ret;
		}
		public function equals(toCompare:BezierPoint):Boolean{
			var posMatch:Boolean = (x==toCompare.x && y==toCompare.y);
			return (toCompare.forwardAngle==forwardAngle && 
					toCompare.forwardDistance==forwardDistance && 
					toCompare.backwardAngle==backwardAngle && 
					toCompare.backwardDistance==backwardDistance);
		}
		public function add(point:*):Point{
			if(point is Point || point is BezierPoint){
				return new Point(x+point.x,y+point.y);
			}
			return null;
		}
		public function toPoint():Point{
			return new Point(x,y);
		}
		override public function toString():String{
			return "(x:"+x+",y:"+y+")";
		}
		public function reset():void{
			_dispatchEvents = false;
			_x = NaN;
			_y = NaN;
		
			_backwardAngle = NaN;
			_backwardDistance = NaN;
			_forwardAngle = NaN;
			_forwardDistance = NaN;
		
			_forwardVector = null;
			_backwardVector = null;
			_bothVector = null;
		
			_pointsInvalid = true;
			_numbersInvalid = false;
		}
		public function release():void{
			pool.releaseObject(this);
		}
	}
}