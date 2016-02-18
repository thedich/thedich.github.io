package org.farmcode.queueing
{
	import flash.events.Event;

	public class QueueEvent extends Event
	{
		public static const STEP_FINISHED_EVENT:QueueEvent = new QueueEvent(STEP_FINISHED);
		
		public static var QUEUE_STARTED:String = "queueStarted";
		public static var QUEUE_FINISHED:String = "queueFinished";
		public static var STEP_FINISHED:String = "stepFinished";
		
		public function QueueEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}