package org.farmcode.core
{
	import flash.events.IEventDispatcher;

	[Event(name="success",type="org.farmcode.core.PendingResultEvent")]
	[Event(name="fail",type="org.farmcode.core.PendingResultEvent")]
	
	public interface IPendingResult extends IEventDispatcher{
		
		function get result():*;
	}
}