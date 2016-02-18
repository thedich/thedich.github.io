package org.farmcode.threading
{
	import flash.events.Event;

	public class ThreadEvent extends Event
	{
		public static const THREAD_BEGIN:String = "threadBegin";
		public static const THREAD_COMPLETE:String = "threadComplete";
		public static const JOB_PROCESS:String = "jobProcess";
		public static const JOB_COMPLETE:String = "jobComplete";
		public static const STEP_COMPLETE:String = "stepComplete";
		
		
		public var thread:AbstractThread;
		
		public function ThreadEvent(thread:AbstractThread, type:String, bubbles:Boolean=false, cancelable:Boolean=false){
			super(type, bubbles, cancelable);
			this.thread = thread;
		}
		
	}
}