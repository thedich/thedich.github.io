package org.farmcode.queueing.queueItems.external
{
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	import org.farmcode.queueing.queueItems.PendingResultQueueItem;

	public class LoaderQI extends PendingResultQueueItem
	{
		override public function get totalSteps():uint{
			return 1;
		}
		
		public var urlRequest:URLRequest;
		public var loader:Loader;
		public var loaderContext:LoaderContext;
		
		public function LoaderQI(loader:Loader=null, urlRequest:URLRequest=null, loaderContext:LoaderContext=null){
			super();
			this.loader = loader;
			this.urlRequest = urlRequest;
			this.loaderContext = loaderContext;
		}
		override public function step(currentStep:uint):void{
			if(loader && urlRequest){
				loader.load(urlRequest,loaderContext);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFail);
			}else{
				throw new Error("LoaderQI needs both a Loader and a URLRequest");
			}
		}
		protected function onComplete(e:Event):void{
			var loaderInfo:LoaderInfo = (e.target as LoaderInfo);
			_result = loaderInfo.content;
			removeListeners(loaderInfo);
			dispatchSuccess()
		}
		protected function onFail(e:Event):void{
			var loaderInfo:LoaderInfo = (e.target as LoaderInfo);
			_result = null;
			removeListeners(loaderInfo);
			dispatchFail();
		}
		protected function removeListeners(contentLoaderInfo:LoaderInfo):void{
			contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onFail);
		}
	}
}