package org.farmcode.queueing
{
	import flash.events.IEventDispatcher;
	
	[Event(name="stepFinished",type="org.farmcode.queueing.QueueEvent")]
	public interface IQueueItem extends IEventDispatcher
	{
		function get totalSteps():uint;
		function step(currentStep:uint):void;
	}
}