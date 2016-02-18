package org.farmcode.threading
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	[Event(name="threadBegin",type="org.farmcode.threading.ThreadEvent")]
	[Event(name="threadComplete",type="org.farmcode.threading.ThreadEvent")]
	public class AbstractThread extends EventDispatcher
	{
		private static var _intendedFPS:Number;
		protected static const instances:Array = [];
		protected static const FRAME_DISPATCHER:Shape = new Shape();
		
		
		public static function get numThreads(): uint{
			return AbstractThread.instances.length;
		}
		
		public static function get intendedFPS():Number{
			return _intendedFPS;
		}
		public static function set intendedFPS(value:Number):void{
			if(value !=_intendedFPS){
				_intendedFPS = value;
				for each(var thread:AbstractThread in instances){
					thread.evaluateProccessTime();
				}
			}
		}
		
		public function get processing():Boolean{
			return _processing;
		}
		public function get intendedThreadSpeed():Number{
			return _intendedThreadSpeed;
		}
		public function set intendedThreadSpeed(value:Number):void{
			value = value>1?1:(value<0?0:value);
			if(value!=_intendedThreadSpeed){
				_intendedThreadSpeed = value;
				evaluateProccessTime();
			}
		}
		protected function get indefinate(): Boolean{
			return isNaN(_processTime);
		}
		
		
		protected var _processTime:Number; // the amount of time that this Thread is allowed to use per frame
		protected var _intendedThreadSpeed:Number; // between 0 - 1
		
		protected var _processing:Boolean;
		
		
		public function AbstractThread(intendedThreadSpeed:Number = 0.5){
			instances.push(this);
			this.intendedThreadSpeed = intendedThreadSpeed;
		}
		public function destroy():void{
			endProcessing();
			var index:int = instances.indexOf(this);
			if(index!=-1){
				instances.splice(index,1);
			}
		}
		protected function evaluateProccessTime():void{
			if(isNaN(intendedFPS)){
				trace("WARNING: AbstractThread.evaluateProccessTime. intendedFPS is not set, thread will not limit processing.");
			}else{
				_processTime = (1000/intendedFPS)*_intendedThreadSpeed;
			}
		}
		protected function beginProcessing():void{
			if(!_processing){
				_processing = true;
				FRAME_DISPATCHER.addEventListener(Event.ENTER_FRAME,process);
				dispatchEvent(new ThreadEvent(this,ThreadEvent.THREAD_BEGIN));
			}
		}
		protected function endProcessing():void{
			if(_processing){
				_processing = false;
				FRAME_DISPATCHER.removeEventListener(Event.ENTER_FRAME,process);
				dispatchEvent(new ThreadEvent(this,ThreadEvent.THREAD_COMPLETE));
			}
		}
		
		protected function process(e:Event=null):void{
			// override this
		}
	}
}