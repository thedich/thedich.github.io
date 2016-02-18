package org.farmcode.queueing.queueItems.functional
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import org.farmcode.queueing.IQueueItem;
	import org.farmcode.queueing.QueueEvent;

	public class DispatchEventQI extends EventDispatcher implements IQueueItem
	{
		public function get totalSteps():uint{
			return 1;
		}
		
		public var event:Event;
		public var eventDispatcher:IEventDispatcher;
		
		public function DispatchEventQI(event:Event=null, eventDispatcher:IEventDispatcher=null){
			this.event = event;
			this.eventDispatcher = eventDispatcher;
		}
		
		public function step(currentStep:uint):void{
			eventDispatcher.dispatchEvent(event);
			dispatchEvent(QueueEvent.STEP_FINISHED_EVENT);
		}
	}
}