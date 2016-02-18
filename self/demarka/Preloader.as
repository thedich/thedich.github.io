package {
	//flash basic
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	
	import flash.net.*;
	import flash.xml.*;
 	import flash.net.*;
	import flash.ui.*;
	
	//Skinner Da Best Moving Class
	import gs.*
	import gs.easing.*;
	import gs.events.*;

	public class Preloader extends MovieClip {
		public static const DOCUMENT_CLASS:String = 'DemarkaIntro';
		public static const ENTRY_FRAME:Number = 3;
		//public static const firstXML:String = 'http://www.floworks.ru/demarka3.xml'
		public static const firstXML:String = 'demarka.xml'
		
		public var loadedSelf:Number;
		public var totalSelf:Number;
		public var xmlBoolLoaded:Boolean;
		public var seflBoolLoaded:Boolean;
		private var boolAnim:Boolean;
		public var program:Sprite;
		private var targetXML:XML; 
		private var preLine:Sprite;
		private var maskLoading:Sprite;
		private var bg:Sprite;
		private var textLoad:TextField;
		private var removedBool:Boolean;
		
		public function Preloader() {
			
			super();
			stop();
			
			stage.align = "TL";
			stage.quality = StageQuality.HIGH;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			var myContextMenu = new ContextMenu();
			myContextMenu.hideBuiltInItems();

			preLine = getChildByName("preloader") as Sprite;
			preLine.height = 0;
			preLine.y = (stage.stageHeight-preLine.height)/2;
			preLine.x = (stage.stageWidth-preLine.width)/2;
		
			var XML_URL:String = firstXML;
			var myXMLURL:URLRequest = new URLRequest(XML_URL);
			var myLoader:URLLoader = new URLLoader();
			myLoader.load(myXMLURL)
			myLoader.addEventListener(Event.COMPLETE, xmlLoaded);

			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progressHandler);
			loaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			
			stage.addEventListener(Event.RESIZE, onLoadResize);
		}
		
		private function onLoadResize(e:Event):void {
			preLine.y = (stage.stageHeight)/2;
			preLine.x = (stage.stageWidth)/2;
			
		}
		
		private function xmlLoaded(e:Event):void {
			xmlBoolLoaded = true;
			targetXML = new XML(e.target.data);
			e.target.removeEventListener(Event.COMPLETE, xmlLoaded);
			}
		
		private function progressHandler(e:ProgressEvent):void {
		
			loadedSelf = int(e.bytesLoaded);
			totalSelf = int(e.bytesTotal);
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function completeHandler(e:Event):void {
			
			e.target.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			e.target.removeEventListener(Event.COMPLETE, completeHandler);
			
			
			TweenMax.to(preLine, .5, {height:0,ease:Sine.easeOut, onComplete:gotoClass});
			function gotoClass():void {
				seflBoolLoaded = true;
				}
				
		}
		
		
		
		private function enterFrameHandler(event:Event):void {
			if(!seflBoolLoaded) {
			preLine.height += (stage.stageHeight*loadedSelf/totalSelf-preLine.height)/2+15;
			}
			
			if (seflBoolLoaded && xmlBoolLoaded) {
						play();
						if (currentFrame >= Preloader.ENTRY_FRAME) {
						removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
						stage.removeEventListener(Event.RESIZE, onLoadResize);
						stop();
						pointEnter();
						}
				}
		}
		
		private function pointEnter():void {
			var programClass:Class = loaderInfo.applicationDomain.getDefinition(Preloader.DOCUMENT_CLASS) as Class;
			var program:Sprite = new programClass(targetXML) as Sprite;
			addChild(program);
		}
		
	}
}