package org.farmcode.queueing
{
	[Event(name="queueStarted",type="au.com.wigglesworld.queueing.QueueEvent")]
	[Event(name="queueFinished",type="au.com.wigglesworld.queueing.QueueEvent")]
	public interface IQueue
	{
		function addQueueItem(queueItem:IQueueItem, prioritise:Boolean=false):void;
		function removeQueueItem(queueItem:IQueueItem):void;
		
		/*function pause():void;
		function resume():void;*/
		
		function clearQueue():void;
		function destroy():void;
	}
}