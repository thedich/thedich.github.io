package org.farmcode.hoborg
{
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	[Event(name="objectReleased",type="org.farmcode.hoborg.events.PoolingEvent")]
	public class Pooler
	{
		public static function setPoolSize(classPath:*, size:uint):*{
			var pool:ObjectPool = getPool(classPath);
			pool.size = size;
		}
		public static function getPoolSize(classPath:*):uint{
			var pool:ObjectPool = getPool(classPath);
			return pool.size;
		}
		
		
		private static var _eventDispatcher:EventDispatcher = new EventDispatcher();
		private static var pools:Dictionary = new Dictionary();
		
		public static function takeObject(classPath:*):*{
			var pool:ObjectPool = getPool(classPath);
			return pool.takeObject();
		}
		public static function releaseObject(object:IPoolable):void{
			var pool:ObjectPool = getPool(object);
			pool.releaseObject(object);
		}
		
		
		
		protected static function getPool(klass:*):ObjectPool{
			if(!(klass is Class)){
				if(klass is String){
					klass = getDefinitionByName(klass);
				}else{
					klass = klass["constructor"]
				}
			}
			var ret:ObjectPool = pools[klass];
			if(!ret){
				var pool:ObjectPool = new ObjectPool(klass);
				ret = pools[klass] = pool;
			}
			return ret;
		}
		
		
		// event dispatching
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void{
			_eventDispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		public static function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void{
			_eventDispatcher.removeEventListener(type, listener, useCapture);
		}
		private static function dispatchEvent(event:Event):Boolean{
			return _eventDispatcher.dispatchEvent(event);
		}
		public static function hasEventListener(type:String):Boolean{
			return _eventDispatcher.hasEventListener(type);
		}
		public static function willTrigger(type:String):Boolean{
			return _eventDispatcher.willTrigger(type);
		}
	}
}