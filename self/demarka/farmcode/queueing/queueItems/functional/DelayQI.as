package org.farmcode.queueing.queueItems.functional
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.farmcode.queueing.IQueueItem;
	import org.farmcode.queueing.QueueEvent;

	public class DelayQI extends EventDispatcher implements IQueueItem
	{
		public function get totalSteps():uint{
			return 1;
		}
		
		public var seconds:Number;
		
		private var _timer:Timer;
		
		public function DelayQI(seconds:Number=0){
			this.seconds = seconds;
		}

		public function step(currentStep:uint):void{
			if(seconds){
				_timer = new Timer(seconds*1000,1);
				_timer.addEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				_timer.start();
			}else{
				onComplete();
			}
		}
		private function onComplete(e:Event=null):void{
			if(_timer){
				_timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onComplete);
				_timer = null;
			}
			dispatchEvent(QueueEvent.STEP_FINISHED_EVENT);
		}
	}
}