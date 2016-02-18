package org.farmcode.core
{
	import flash.events.Event;

	public class PendingResultEvent extends Event
	{
		public static const SUCCESS:String = "success";
		public static const FAIL:String = "fail";
		
		public static const SUCCESS_EVENT:PendingResultEvent = new PendingResultEvent(SUCCESS);
		public static const FAIL_EVENT:PendingResultEvent = new PendingResultEvent(FAIL);
		
		public function PendingResultEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}