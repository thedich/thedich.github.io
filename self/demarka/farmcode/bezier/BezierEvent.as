package org.farmcode.bezier
{
	import flash.events.Event;

	public class BezierEvent extends Event
	{
		
		public static const POSITION_CHANGED:String = "positionChanged";
		public static const VECTOR_CHANGED:String = "vectorChanged";
		public static const SHAPE_CHANGED:String = "shapeChanged";
		
		public function BezierEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
		}
	}
}