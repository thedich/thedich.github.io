package org.farmcode.queueing
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	[Event(name="queueStarted",type="au.com.wigglesworld.queueing.QueueEvent")]
	[Event(name="queueFinished",type="au.com.wigglesworld.queueing.QueueEvent")]
	public class Queue extends EventDispatcher implements IQueue
	{
		public var _queue:Array = [];
		public var _runningItem:IQueueItem;
		public var _stepsTaken:int = 0;
		protected var _pause:Boolean = false;
		
		/*public function pause():void{
			_pause = false;
		}
		
		public function resume():void{
			if(!_pause){
				_pause = true;
				doNext();
			}
		}*/
		
		public function addQueueItem(queueItem:IQueueItem, prioritise:Boolean=false):void{
			if(prioritise)_queue.unshift(queueItem);
			else _queue.push(queueItem);
			startQueue();
		}
		public function destroy():void{
			clearQueue();
			if(_runningItem){
				_runningItem.removeEventListener(Event.COMPLETE, onComplete);
				_runningItem = null;
			}
		}
		public function clearQueue():void{
			_queue = [];
			_runningItem = null;
		}
		public function removeQueueItem(queueItem:IQueueItem):void{
			var index:int = _queue.indexOf(queueItem);
			if(index!=-1){
				_queue.splice(index,1);
			}
		}
		
		protected function startQueue():void{
			if(!_runningItem && _queue.length){
				dispatchEvent(new QueueEvent(QueueEvent.QUEUE_STARTED));
				doNext();
			}
		}
		protected function doNext():void{
			if(!_pause){
				if(!_runningItem || _runningItem.totalSteps==_stepsTaken){
					if(_runningItem){
						_runningItem.removeEventListener(QueueEvent.STEP_FINISHED, doNext);
						_runningItem = null;
					}
					if(_queue.length){
						_runningItem = _queue.shift();
						_runningItem.addEventListener(QueueEvent.STEP_FINISHED, onComplete);
						_stepsTaken = 0;
					}else{
						dispatchEvent(new QueueEvent(QueueEvent.QUEUE_FINISHED));
						return;
					}
				}
				_runningItem.step(_stepsTaken++);
			}
		}
		protected function onComplete(e:Event):void{
			doNext();
		}
	}
}