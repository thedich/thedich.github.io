package {
	//flash basic
	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	
	import flash.net.*;
	import flash.xml.*;
	import flash.ui.*;
	
	//Skinner Da Best Moving Class
	import gs.*
	import gs.easing.*;
	import gs.events.*;

	public class DemarkaIntro extends Sprite {
		private var videoLogo:MovieClip;
		private var fonn:Sprite;
		private var maskF:Object;
		private var xmlData:XML;
		// Catalog Array;
		private var cPicSmall:Array;
		private var cPicBig:Array;
		// Portfolio Array;
		private var pPicSmall:Array;
		private var pPicBig:Array;
		//contact Array
		private var conA:Array;
		private var conALoaded:Array = new Array();
		private var conLink:Array;
		
		private var loadedPicsArray:Array = new Array();		
		private var loadPlace:MovieClip;
		private var maskL:Object;
		private var masked:Object;
		private var loText:Object;
		private var logo:Object;
		private var numS:Object;
		
		private var maxNum:Number;
		private var nLoaded:Number = 0;
		
		private var picS:MovieClip;
		private var cLoadedPic:Array = new Array();
		private var pLoadedPic:Array = new Array();
		
		private var menuAndNavi:Sprite;
		private var alingY:Number = 0;
		private var allArray:Array;
		
		private var pho:Sprite;
		
		//sounds
		private var beginB:Sound;
		private var beginOnLoad:Sound;
		private var beginReverse:Sound;
		private var clickItem:Sound;
		private var channel:SoundChannel = new SoundChannel();
		private var channelLoop:SoundChannel = new SoundChannel();
		private var soundTrans:SoundTransform;

		public function DemarkaIntro(xml:XML) {
			this.xmlData = xml;
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			this.parseXMLdata();
			
			this.beginB = new BeginBoom();
			this.beginOnLoad = new BeginLoading();
			this.beginReverse = new reverseBegin();
			this.clickItem = new clickItems();
			
			soundTrans = new SoundTransform(.7, 0);
			channel.soundTransform = soundTrans;
			channelLoop.soundTransform = new SoundTransform(.3, 0);
			
			
			var timeObject = new Object();
			TweenMax.to(timeObject, 2.5, {height:150, ease:Sine.easeOut, onComplete:beginSoundOn});
			function beginSoundOn():void {
				channelLoop = beginOnLoad.play();
				channelLoop.soundTransform = new SoundTransform(.3, 0);
				channelLoop.addEventListener(Event.SOUND_COMPLETE, onSoundLoop);
				}
		}
		
		private function parseXMLdata():void {
			xmlData.ignoreWhite = true;
			var howmuch:Number = xmlData.child("catalog").child("item").length();
			var howmuch2:Number = xmlData.child("portfolio").child("item").length();
			var howmuch3:Number = xmlData.child("contacts").child("item").length();
			
			// set arrays to null
			cPicSmall = [];
			cPicBig = [];
			pPicSmall = [];
			pPicBig = [];
			
			//
			conA = [];
			conLink = [];
			
			for (var i=0;i<howmuch; i++) {
				cPicSmall[i] = xmlData.child("catalog").child("item")[i].attribute("picSmall");
				cPicBig[i] = xmlData.child("catalog").child("item")[i].attribute("picBig");
				}
				
			for (var j=0;j<howmuch2; j++) {
				pPicSmall[j] = xmlData.child("portfolio").child("item")[j].attribute("picSmall");
				pPicBig[j] = xmlData.child("portfolio").child("item")[j].attribute("picBig");
				}
				
			for (var k=0;k<howmuch3; k++) {
				conA[k] = xmlData.child("contacts").child("item")[k].attribute("picSmall");
				conLink[k] = xmlData.child("contacts").child("item")[k].attribute("picBig");
				}		
			
			var systemA = cPicSmall.concat(pPicSmall);
			allArray = systemA.concat(conA);
			getLoaderPics();
			}
			
		
		private function onAdd(e:Event):void {
			
			videoLogo = new video();
			videoLogo.y = (stage.stageHeight)/2;
			videoLogo.x = (stage.stageWidth)/2-13;
			
			addChild(videoLogo);
			
			loadPlace = new loadPlaceBegin();
			loadPlace.y = (stage.stageHeight)/2;
			loadPlace.x = (stage.stageWidth)/2;
			
			maskL = loadPlace.getChildByName('maskPre');
			masked = loadPlace.getChildByName('mackedmc');
			loText = masked.getChildByName('loadText');
			numS = loText.getChildByName('numLoad');
			picS = masked.getChildByName('picSlide');
			
			numS.text = nLoaded+'/'+allArray.length;
			
			TweenMax.to(picS, .2, {colorMatrixFilter:{saturation:0}});
			
			masked.mask = maskL;
			maskL.height = 0;
			TweenMax.to(maskL, .3, {height:150,dealy:1, ease:Sine.easeOut});
			TweenMax.to(maskL, .4, {width:400,delay:1.3, ease:Sine.easeOut});
			
			var sObj = new Object();
			TweenMax.to(sObj, 1.3, {height:150, ease:Sine.easeOut, onComplete:beginSoundClick});
			function beginSoundClick():void {
				channel = clickItem.play(85);
				channel = beginB.play();
				channel.soundTransform = new SoundTransform(.7, 0);
				}
			
			addChild(loadPlace)
			stage.addEventListener(Event.RESIZE, onStageResize);
			}
			
		private function getLoaderPics():void {
			for (var i=0; i<allArray.length; i++){
				
				var url:URLRequest = new URLRequest(allArray[i]);
				var loader:Loader = new Loader();
				loader.load(url)
				loadedPicsArray.push(loader);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPicsComplete);
				//loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,ErrorEventSame);
				}
			}
			
		private function onSoundLoop(e:Event):void {
			channelLoop = beginOnLoad.play();
			channelLoop.soundTransform = new SoundTransform(.3, 0);
			channelLoop.addEventListener(Event.SOUND_COMPLETE, onSoundLoop);
			}	
			
		private function onPicsComplete(e:Event):void {
			e.target.removeEventListener(Event.COMPLETE, onPicsComplete);
			nLoaded++;
			
			numS.text = nLoaded+'/'+allArray.length;
			if(nLoaded == allArray.length){
				cLoadedPic = loadedPicsArray.slice(0,cPicSmall.length);
				pLoadedPic = loadedPicsArray.slice(cPicSmall.length,cPicSmall.length+pPicSmall.length);
				conALoaded = loadedPicsArray.slice(cPicSmall.length+pPicSmall.length,loadedPicsArray.length);
				videoLogo.addEventListener(Event.ENTER_FRAME, videoOnEnter);
				}
				
			picS.addChild(e.target.content);
			}
			
		private function videoOnEnter(e:Event):void {
			if(e.target.currentFrame >='45' && e.target.currentFrame <='121') {
				e.target.stop();
				e.target.removeEventListener(Event.ENTER_FRAME, videoOnEnter);
				maskMove();
				}
			
			}
			
		private function maskMove():void {
			TweenMax.to(maskL, .4, {x:400, ease:Sine.easeOut,onComplete:removeLoader});
			channel = beginReverse.play();
			function removeLoader():void {
				removeChild(loadPlace)
				getMenuAndNavigation();
				}
			}
				
		private function getMenuAndNavigation():void {
			alingY = 123;
			TweenMax.to(videoLogo, .3, {y:(stage.stageHeight)/2 - alingY, delay:0.3, ease:Sine.easeOut});
			menuAndNavi = new MenuAndNavigation(cLoadedPic,cPicBig,pLoadedPic,pPicBig,conALoaded,conLink);
			addChild(menuAndNavi);
			
			channelLoop.removeEventListener(Event.SOUND_COMPLETE, onSoundLoop);
			
			pho = new phone();
			pho.x = (stage.stageWidth - pho.width)/2;
			pho.y = stage.stageHeight+pho.height+200;
			var neY =  stage.stageHeight/2 +(stage.stageHeight/2-pho.height)/2+135/2;
			TweenMax.to(pho, .3, {y:neY, delay:0.2, ease:Sine.easeOut});
			
			//pho.blendMode = BlendMode.DIFFERENCE;
			addChild(pho);
			}
			
		private function onStageResize(e:Event):void {
			videoLogo.y = (stage.stageHeight)/2 - alingY;
			videoLogo.x = (stage.stageWidth)/2-13;
			
			if(loadPlace) {
			loadPlace.y = (stage.stageHeight)/2;
			loadPlace.x = (stage.stageWidth)/2;
				}
				
			if(pho) {
				pho.x = (stage.stageWidth - pho.width)/2;
				pho.y = stage.stageHeight/2 +(stage.stageHeight/2-pho.height)/2+135/2;
				}	
			}
			
		private function videoOneMove(e:Event):void {
			videoLogo.gotoAndPlay('123');
			videoLogo.addEventListener(Event.ENTER_FRAME, onOneMoveStop);
			}
			
		private function onOneMoveStop(e:Event):void {
			if(e.target.currentFrame == '45') {
				e.target.stop();
				e.target.removeEventListener(Event.ENTER_FRAME, onOneMoveStop);
				}
			}
			
			
	}
}