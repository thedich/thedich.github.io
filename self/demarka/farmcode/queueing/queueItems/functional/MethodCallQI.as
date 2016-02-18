package org.farmcode.queueing.queueItems.functional
{
	import org.farmcode.queueing.queueItems.PendingResultQueueItem;

	public class MethodCallQI extends PendingResultQueueItem
	{
		override public function get totalSteps():uint{
			return callTimes;
		}
		
		public var interceptErrors:Boolean = false;
		
		public var func:Function;
		public var parameters:Array;
		public var callTimes:uint = 1;
		
		public function MethodCallQI(func:Function=null, parameters:Array=null){
			this.func = func;
			this.parameters = parameters;
		}
		
		override public function step(currentStep:uint):void{
			if(interceptErrors){
				try{
					_result = func.apply(null,parameters);
					dispatchSuccess();
				}catch(e:Error){
					dispatchFail();
				}
			}else{
				_result = func.apply(null,parameters);
				dispatchSuccess();
			}
		}
	}
}