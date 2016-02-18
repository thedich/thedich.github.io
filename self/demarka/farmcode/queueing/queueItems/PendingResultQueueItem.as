package org.farmcode.queueing.queueItems
{
	import flash.events.EventDispatcher;
	
	import org.farmcode.core.IPendingResult;
	import org.farmcode.core.PendingResultEvent;
	import org.farmcode.queueing.IQueueItem;
	import org.farmcode.queueing.QueueEvent;

	[Event(name="success",type="org.farmcode.core.PendingResultEvent")]
	[Event(name="fail",type="org.farmcode.core.PendingResultEvent")]
	[Event(name="stepFinished",type="org.farmcode.queueing.QueueEvent")]
	public class PendingResultQueueItem extends EventDispatcher implements IQueueItem, IPendingResult
	{
		public function get totalSteps():uint{
			// override me
			return 0;
		}
		
		public function get result():*{
			return _result;
		}
		
		public function PendingResultQueueItem(){
			super();
		}
		
		
		public function step(currentStep:uint):void{
			// override me
		}
		
		protected var _result:*;
		
		protected function dispatchSuccess():void{
			dispatchEvent(PendingResultEvent.SUCCESS_EVENT);
			dispatchEvent(QueueEvent.STEP_FINISHED_EVENT);
		}
		protected function dispatchFail():void{
			dispatchEvent(PendingResultEvent.SUCCESS_EVENT);
			dispatchEvent(QueueEvent.STEP_FINISHED_EVENT);
		}
	}
}