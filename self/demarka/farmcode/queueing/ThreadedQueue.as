package org.farmcode.queueing
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import org.farmcode.threading.AbstractThread;
	import org.farmcode.threading.ThreadEvent;
	
	[Event(name="jobProcess",type="org.farmcode.threading.ThreadEvent")]
	[Event(name="jobComplete",type="org.farmcode.threading.ThreadEvent")]
	public class ThreadedQueue extends AbstractThread implements IQueue
	{
		public static function get intendedFPS():Number{
			return AbstractThread.intendedFPS;
		}
		public static function set intendedFPS(value:Number):void{
			AbstractThread.intendedFPS = value;
		}
		public static function getThread(id:String, newThreadSpeed:Number = 0.5):ThreadedQueue{
			for each(var thread:AbstractThread in AbstractThread.instances){
				var cast:ThreadedQueue = (thread as ThreadedQueue);
				if(cast.id==id){
					return cast;
				}
			}
			return new ThreadedQueue(id, newThreadSpeed);
		}
		override public function get processing():Boolean{
			return (_queueItems.length>0);
		}
		
		public var id:String;
		
		protected var _queueItems:Array = [];
		protected var _currentItem:IQueueItem;
		
		protected var _frameStartTime:int;
		protected var _currentStepsDone:int;
		
		public function ThreadedQueue(id:String=null, intendedThreadSpeed:Number = 0.5){
			super(intendedThreadSpeed);
			this.id = id;
		}
		public function addQueueItem(queueItem:IQueueItem, prioritise:Boolean=false):void{
			var index:int = _queueItems.indexOf(queueItem);
			if(index==-1){
				var oldLength:Number = _queueItems.length;
				if(prioritise)_queueItems.unshift(queueItem);
				else _queueItems.push(queueItem);
				if(!oldLength)beginProcessing()
			}
		}
		public function removeQueueItem(queueItem:IQueueItem):void{
			var index:int = _queueItems.indexOf(queueItem);
			if(index!=-1){
				_queueItems.splice(index,1);
				if(!_queueItems.length)endProcessing()
			}
		}
		/*public function prioritiseJob(job:IThreadJob):void{
			var index:int = _queueItems.indexOf(job);
			if(index!=-1 && index!=0){
				_queueItems.splice(index,1);
				_queueItems.unshift(job);
			}
		}*/
		public function clearQueue():void{
			endProcessing();
			_queueItems = [];
		}
		override public function destroy():void{
			clearQueue();
			super.destroy()
		}
		override protected function beginProcessing():void{
			if(!_processing){
				_currentItem = _queueItems[0];
				_currentItem.addEventListener(QueueEvent.STEP_FINISHED,process);
				_currentStepsDone = 0;
				
				_processing = true;
				dispatchEvent(new ThreadEvent(this,ThreadEvent.THREAD_BEGIN));
				FRAME_DISPATCHER.addEventListener(Event.ENTER_FRAME,onFrame);// always delay the beginning so that listeners can be added to events which finish immediately
			}
		}
		override protected function endProcessing():void{
			if(_processing){
				if(_currentItem){
					_currentItem.removeEventListener(QueueEvent.STEP_FINISHED,process);
					_currentItem = null;
				}
				_currentStepsDone = 0;
				
				_processing = false;
				FRAME_DISPATCHER.removeEventListener(Event.ENTER_FRAME,onFrame);
				dispatchEvent(new ThreadEvent(this,ThreadEvent.THREAD_COMPLETE));
			}
		}
		protected function onFrame(e:Event):void{
			FRAME_DISPATCHER.removeEventListener(Event.ENTER_FRAME,onFrame);
			_frameStartTime = getTimer();
			process();
		}
		override protected function process(e:Event=null):void{
			var frameTime:Number = getTimer()-_frameStartTime;
			if(frameTime>_processTime){
				FRAME_DISPATCHER.addEventListener(Event.ENTER_FRAME,onFrame);
				return;
			}
			
			var remaining:int = _currentItem.totalSteps-_currentStepsDone;
			if(!remaining){
				_currentItem.removeEventListener(QueueEvent.STEP_FINISHED,process);
				_currentItem = null;
				_queueItems.shift();
				if(_queueItems.length){
					_currentItem = _queueItems[0];
					_currentItem.addEventListener(QueueEvent.STEP_FINISHED,process);
					_currentStepsDone = 0;
				}else{
					endProcessing();
					return;
				}
			}
			_currentItem.step(_currentStepsDone++);
		}
		/*override public function dispatchEvent(event:Event):Boolean{
			if(_currentItem && event is ThreadEvent)_currentItem.dispatchEvent(event);
			return super.dispatchEvent(event);
		}*/
	}
}