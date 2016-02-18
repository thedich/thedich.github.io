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

	public class MenuAndNavigation extends Sprite {
		
		private var cLoaded:Array = new Array();
		private var cBig:Array = new Array();
		private var pLoaded:Array = new Array();
		private var pBig:Array = new Array();
		private var conA:Array = new Array();
		private var conLink:Array = new Array();
		
		private var nX:Number = 4;
		private var nY:Number = 2;
		
		private var pointAr:Array;
		private var enterCount:Number;
		private var nCount:Number;
		
		private var workArr:Array;
		private var linkArray:Array;
		
		private var itemsAr:Array;
		private var holderGallery:Sprite;
		private var numConteiner:Sprite;
		
		private var topMenu:Sprite;
		private var loadB:Sprite;
		private var bigHolder:Sprite;
		
		private var numCreated:Boolean = false;
		private var portBool:Boolean = false;
		private var animDone:Boolean = false;
		private var conBool:Boolean = false;
		
		private var musicV:Sprite;
		private var mCon:Object;
		
		private var colorArray:Array;
		private var rColor:String;
		
		private var fulls:Sprite;
		
		//sounds
		private var mainTheme:Sound;
		private var channel:SoundChannel = new SoundChannel();
		private var soundTrans:SoundTransform;
		
		private var musicOnOf:Boolean = true;
		private var musPosition:Number;
		
		//sounds
		private var beginReverse:Sound;
		private var clickItem:Sound;
		private var rollOverSound:Sound;
		private var menuClick:Sound;
		private var channelAnoser:SoundChannel = new SoundChannel();
		
		public function MenuAndNavigation(clp:Array,cbp:Array,plp:Array,pbp:Array, con:Array, conL:Array) {
			
			this.cLoaded = clp;
			this.cBig = cbp;
			this.pLoaded = plp;
			this.pBig = pbp;
			this.conA = con;
			this.conLink = conL;
	
			colorArray = ["0x673b56","0xc871a3","0xffb1b1","0x657d55","0x80c692","0x5a5056","0xde9ce0","0xa99de1","0xa8d7f1","0x7eded5"];
			var rN:Number = Math.floor(Math.random()*colorArray.length);
			rColor = colorArray[rN];
			
			mainTheme = new Sound();
			mainTheme.load(new URLRequest('background.mp3'));
			
			soundTrans = new SoundTransform(.3, 0);
			channel = mainTheme.play();
			channel.soundTransform = soundTrans;
			channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			
			channelAnoser.soundTransform = new SoundTransform(.3, 0);
			//channelAnoser = clickItem.play(90);
			//channelAnoser.soundTransform = new SoundTransform(.3, 0);
			this.beginReverse = new reverseBegin();
			this.clickItem = new clickItems();
			this.rollOverSound = new rollOverS();
			this.menuClick = new clickMenu();
			
		}
		
		private function soundComplete(e:Event):void {
			channel = mainTheme.play();
			channel.soundTransform = soundTrans;
			channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
			}
		
		//random on minmax
		private function randRange(min:Number, max:Number):Number {
    		var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
    		return randomNum;
		}	
		
		private function onAdd(e:Event):void {
			
			getPoints();
			enterCount = 0;
			nCount = 0;
			
			workArr = [];
			workArr = cLoaded;
			
			linkArray = [];
			linkArray = cBig;
			
			createItems();
			createMenuTop();
			getMusic();
			
			stage.addEventListener(Event.RESIZE, onStageResize);
			}
			
		private function getMusic():void {
			musicV = new music();
			musicV.alpha = 0;
			TweenMax.to(musicV, .4, {alpha:1, delay:.2, ease:Sine.easeOut});
			
			mCon = musicV.getChildByName('mControl');
			addChild(musicV);
			alignMusic();
			
			musicV.addEventListener(MouseEvent.ROLL_OVER, mOnRollOver);
			musicV.addEventListener(MouseEvent.ROLL_OUT, mOnRollOut);
			musicV.addEventListener(MouseEvent.CLICK, mOnRollClick);
			
			fulls = new fullscreen();
			fulls.alpha = 0;
			var someFull = fulls.getChildByName('full');
			someFull.mouseEnabled = false;
			
			TweenMax.to(fulls, .4, {alpha:1, delay:.2, ease:Sine.easeOut});
			addChild(fulls);
			alignFull();
			
			fulls.addEventListener(MouseEvent.ROLL_OVER, fullOnRollOver);
			fulls.addEventListener(MouseEvent.ROLL_OUT, fullOnRollOut);
			fulls.addEventListener(MouseEvent.CLICK, fullOnRollClick);
			}
			
		private function alignFull():void {
			if(fulls) {
			fulls.x = (stage.stageWidth - musicV.width)/2+3;
			fulls.y = stage.stageHeight-10;
				}
			}
			
		private function mOnRollOver(e:MouseEvent):void {
			channelAnoser = rollOverSound.play(125);
			channelAnoser.soundTransform = new SoundTransform(.3, 0);
			e.target.useHandCursor = true;
			e.target.buttonMode = true;
			TweenMax.to(e.target, .2, {colorMatrixFilter:{colorize:rColor,brightness:1}});
			}
		
		private function mOnRollOut(e:MouseEvent):void {
			TweenMax.to(e.target, .2, {colorMatrixFilter:{colorize:"0xFFFFFF",brightness:1}});
			}
			
		private function mOnRollClick(e:MouseEvent):void {
			
			channelAnoser = clickItem.play(95);
			channelAnoser.soundTransform = new SoundTransform(.7, 0);
			
			if(musicOnOf) { 
					mCon.stop();
					musPosition = channel.position;
					channel.stop();
					musicOnOf = false;
					
				} 
				else {
					mCon.play();
					channel = mainTheme.play(musPosition);
					channel.soundTransform = soundTrans;
					musicOnOf = true;
					
					}
			}
			
		private function fullOnRollOver(e:MouseEvent):void {
			channelAnoser = rollOverSound.play(125);
			channelAnoser.soundTransform = new SoundTransform(.3, 0);
			e.target.useHandCursor = true;
			e.target.buttonMode = true;
			TweenMax.to(e.target, .2, {colorMatrixFilter:{colorize:rColor,brightness:1}});
			}
		
		private function fullOnRollOut(e:MouseEvent):void {
			TweenMax.to(e.target, .2, {colorMatrixFilter:{colorize:"0xFFFFFF",brightness:1}});
			}
			
		private function fullOnRollClick(e:MouseEvent):void {
			
			channelAnoser = clickItem.play(95);
			channelAnoser.soundTransform = new SoundTransform(.7, 0);
			
			var thisFull = e.target.getChildByName('full');
		
			if(thisFull.currentFrame == 1) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
				thisFull.play();
				
				}
				
			if(thisFull.currentFrame == 2) {
				stage.displayState = StageDisplayState.NORMAL;
				thisFull.play();
				}	
				
			}	
			
			
			
		private function createMenuTop():void {
			
			var topLogo = new logoTop();
			var cata = new catalog();
			var port = new portfolio();
			var contact = new contacts();
			
			cata.x = 179+1;
			port.x = 179*2+2;
			contact.x = 179*3+3;
			
			topLogo.y = -200;
			cata.y = -201;
			port.y = -200;
			contact.y = -200;
			
			topMenu = new Sprite();
			topMenu.addChild(topLogo);
			topMenu.addChild(cata);
			topMenu.addChild(port);
			topMenu.addChild(contact);
			
			topMenu.x = (stage.stageWidth - topMenu.width)/2;
			addChild(topMenu);
			
			
			TweenMax.to(topLogo, .4, {y:0, delay:.2, ease:Sine.easeOut});
			TweenMax.to(cata, .4, {y:0, delay:.4, ease:Sine.easeOut});
			TweenMax.to(port, .4, {y:0, delay:0, ease:Sine.easeOut});
			TweenMax.to(contact, .4, {y:0, delay:.3, ease:Sine.easeOut});
			//00CCFF
			var mAr:Array = [topLogo,cata,port,contact];
			for (var i=0; i<mAr.length; i++) {
				if(i == 1) {
					mAr[i].enabled = false;
					var thisBut = mAr[i].getChildByName('bgBut');
					TweenMax.to(thisBut, .2, {colorMatrixFilter:{colorize:rColor,brightness:.8}});
					}
				mAr[i].name = i;
				if (i>0){
					mAr[i].addEventListener(MouseEvent.ROLL_OVER, onMenuRollOver);
					mAr[i].addEventListener(MouseEvent.ROLL_OUT, onMenuRollOut);
					mAr[i].addEventListener(MouseEvent.CLICK, onMenuRollClick);
					}
					else {
						
						}
				}
			}
			
		private function alignMusic():void {
			if(musicV) {
			musicV.x = (stage.stageWidth - musicV.width)/2-15;
			musicV.y = stage.stageHeight-10;
				}
			}	
			
		private function onMenuRollOver(e:MouseEvent):void {
			if(e.target.enabled) {
				channelAnoser = rollOverSound.play(125);
				channelAnoser.soundTransform = new SoundTransform(.3, 0);
				e.target.useHandCursor = true;
				e.target.buttonMode = true;
				
				var thisBut = e.target.getChildByName('bgBut');
				TweenMax.to(thisBut, .2, {colorMatrixFilter:{colorize:rColor,brightness:.8}});
				}
			}
			
			
		private function onMenuRollOut(e:MouseEvent):void {
			if(e.target.enabled) {
				e.target.useHandCursor = true;
				e.target.buttonMode = true;
				
				var thisBut = e.target.getChildByName('bgBut');
				TweenMax.to(thisBut, .2, {colorMatrixFilter:{colorize:"0xFFFFFF",brightness:1}});
				}
			}
			
		private function onMenuRollClick(e:MouseEvent):void {
				if(e.target.parent.enabled) {
					
					channelAnoser = menuClick.play();
					channelAnoser.soundTransform = new SoundTransform(.7, 0);
			
						for (var i=0; i<topMenu.numChildren; i++) {
							var thisB = topMenu.getChildAt(i)
							thisB.enabled = true;
							var thisBut = thisB.getChildByName('bgBut');
							TweenMax.to(thisBut, .2, {colorMatrixFilter:{colorize:"0xFFFFFF",brightness:1}});
							if (e.target.parent.name == i) {
									e.target.parent.enabled = false;
									var bu = e.target.parent.getChildByName('bgBut');
									TweenMax.to(bu, .2, {colorMatrixFilter:{colorize:rColor,brightness:.8}});
									//dispatchEvent(new Event('oneMove'));
									if(i == 1) {
										portBool = true;
										conBool = false;
										removeNums();
										
										workArr = [];
										workArr = cLoaded;
										
										linkArray = [];
										linkArray = cBig;
										
										removeItems(nCount);
										//addEventListener(Event.ENTER_FRAME, removeEnterFrame);
										}
									
									if(i == 2) {
										portBool = true;
										conBool = false;
										removeNums();
										workArr = [];
										workArr = pLoaded;
										
										linkArray = [];
										linkArray = pBig;
										
										removeItems(nCount);
	
										}
										
									if(i == 3) {
										portBool = true;
										conBool = true;
										removeNums();
										workArr = [];
										workArr = conA;
										
										linkArray = [];
										linkArray = conLink;
										
										removeItems(nCount);
	
										}	
									
									}
							}
					}
			}	
			
			
		private function createItems():void {
			if(!holderGallery){
				holderGallery = new Sprite();
				addChild(holderGallery);
				}
			addEventListener(Event.ENTER_FRAME, onFrame);
			}	
			
		private function getPoints():void {
			
			pointAr = new Array();
			itemsAr = new Array();
			
			var centerPx = (stage.stageWidth - nX*180)/2;
			var centerPy = (stage.stageHeight - nY*135)/2;
			
			for (var j=0;j<nY;j++) {
				for (var i=0; i<nX; i++) {
					var itemH = new itemHolder();
					pointAr.push(new Point ((centerPx+180/2)+i*180,(centerPy+135/2)+j*135));
					itemsAr.push(itemH);
					}
				}
			}
			
		private function onFrame(e:Event): void {
			var full = nX*nY;
			
			if (enterCount<full) {
			
				if (workArr[enterCount+nX*nY*nCount]) {
					var thisPic = workArr[enterCount+nX*nY*nCount].content;
					thisPic.x = -thisPic.width/2;
					thisPic.y = -thisPic.height/2;
					itemsAr[enterCount].addChild(thisPic);
				}
				if(enterCount==0){
					disableClicks();
					}
				var getRandom:Number = Math.random()/2;
				var targetName = enterCount+nX*nY*nCount;
				
				itemsAr[enterCount].x = pointAr[enterCount].x;
				itemsAr[enterCount].y = pointAr[enterCount].y + (stage.stageHeight);
				itemsAr[enterCount].alpha = .77;
				itemsAr[enterCount].name = targetName;
				
				itemsAr[enterCount].addEventListener(MouseEvent.ROLL_OVER, onItemRollOver);
				itemsAr[enterCount].addEventListener(MouseEvent.ROLL_OUT, onItemRollOut);
				itemsAr[enterCount].addEventListener(MouseEvent.CLICK, onItemClick);
				holderGallery.addChild(itemsAr[enterCount]);
				
				TweenMax.to(itemsAr[enterCount], .4, {x:pointAr[enterCount].x,y:pointAr[enterCount].y, delay:getRandom, ease:Sine.easeOut});
				TweenMax.to(itemsAr[enterCount], 1, {colorMatrixFilter:{saturation:0}});
				}
				else {
					ableClicks();
					removeEventListener(Event.ENTER_FRAME, onFrame);
					if(!numCreated){createNums();}
					}
				
			enterCount++;
			}
			
		private function disableClicks():void {
			var dis = new Sprite();
			dis.name = 'dis';
			dis.graphics.beginFill(0x000,1)
			dis.graphics.drawRect(0,0,100,100);
			dis.width = stage.stageWidth;
			dis.height = stage.stageHeight;
			dis.alpha = 0;
			
			addChild(dis)
			}
			
		private function ableClicks():void {
			removeChild(getChildByName('dis'));
			}	
			
		private function onItemRollOver(e:MouseEvent):void {
			channelAnoser = rollOverSound.play(125);
			channelAnoser.soundTransform = new SoundTransform(.3, 0);
			e.target.useHandCursor = true;
			e.target.buttonMode = true;
			
			var maskH = e.target.getChildByName('maskItem');
			TweenMax.to(maskH, .3, {width:200,height:150, ease:Sine.easeOut});
			TweenMax.to(e.target, 1, {colorMatrixFilter:{saturation:1}});
			TweenMax.to(e.target, .3, {alpha:1, ease:Sine.easeOut});
			var thisIndex = holderGallery.getChildByName(e.target.name);
			holderGallery.setChildIndex(thisIndex, holderGallery.numChildren - 1);
			}
			
		private function onItemRollOut(e:MouseEvent):void {
			var maskH = e.target.getChildByName('maskItem');
			TweenMax.to(maskH, .2, {width:180,height:135, ease:Sine.easeOut});
			TweenMax.to(e.target, 1, {colorMatrixFilter:{saturation:0}});
			TweenMax.to(e.target, .3, {alpha:.77, ease:Sine.easeOut});
			}
			
		private function onItemClick(e:MouseEvent):void {
			
			channelAnoser = clickItem.play(95);
			channelAnoser.soundTransform = new SoundTransform(.7, 0);
			
			if(conBool) {
				 for (var j=0; j<workArr.length; j++) {
						if(e.target.name == j) {
							var f = conLink[j].toString();
							
							if(f !== '') {
								 bigPicLink(j);
								}
								else {
									 var url:URLRequest = new URLRequest('http://maps.yandex.ru/?text=%D0%A0%D0%BE%D1%81%D1%81%D0%B8%D1%8F%2C%20%D0%A1%D0%B0%D0%BD%D0%BA%D1%82-%D0%9F%D0%B5%D1%82%D0%B5%D1%80%D0%B1%D1%83%D1%80%D0%B3%2C%20%D1%83%D0%BB%D0%B8%D1%86%D0%B0%20%D0%91%D0%BE%D0%BB%D1%8C%D1%88%D0%B0%D1%8F%20%D0%A0%D0%B0%D0%B7%D0%BD%D0%BE%D1%87%D0%B8%D0%BD%D0%BD%D0%B0%D1%8F%2C%204&sll=30.292449%2C59.958314&sspn=0.01096%2C0.004117&l=map');
									 navigateToURL(url,'_blank');
									}
						}
					}
				
				}
				else {
					for (var i=0; i<workArr.length; i++) {
						if(e.target.name == i) {
						bigPicLink(i);
					}
				}
			}
			}
			
		private function bigPicLink(n:Number):void {
			disableClicks();
			
			var url:URLRequest = new URLRequest(linkArray[n]);
			var loaderB:Loader = new Loader();
			loaderB.load(url)
			loaderB.contentLoaderInfo.addEventListener(Event.COMPLETE, onBigComplete);
			getLoaderBig();
			}
			
		private function onBigComplete(e:Event):void {
			//var thisB = addChild(e.target.content);
			bigHolder = new PicViewer(e.target.content,rColor);
			addChild(bigHolder);
			
			bigHolder.addEventListener('removePicBig', onCloseClass);
			ableClicks();
			removeLoaderBig();
			}
			
		private function onCloseClass(e:Event):void {
			e.target.parent.removeChild(e.target);
			}	
			
		private function getLoaderBig():void {
			loadB = new loaderBig();
			loadB.x = stage.stageWidth/2;
			loadB.y = stage.stageHeight/2-120;
			loadB.mouseEnabled = false;
			
			TweenMax.to(loadB, .1, {colorMatrixFilter:{colorize:rColor,brightness:.7}});
			loadB.blendMode = BlendMode.ADD;
			var lMove = loadB.getChildByName('lineMove');
			TweenMax.to(lMove, 1, {x:100, onComplete:onEndMove});
			addChild(loadB);
			
			function onEndMove(): void {
				lMove.x = 36;
				TweenMax.to(lMove, 1, {x:100, onComplete:onEndMove});
				}
			}
			
		private function removeLoaderBig():void {
			removeChild(loadB);
			}	
			
		private function createNums():void {
			
			
			var needNums = int(workArr.length/(nX*nY))+1;
			numConteiner = new Sprite();
			
			if(int(workArr.length/(nX*nY)) == workArr.length/(nX*nY)) {
					needNums -=1;    
					}
			
			for (var i=0; i< needNums; i++) {
					var numm = new numHolder();
					numm.x = i*30;
					numm.name = i;
					
					var line = numm.getChildByName('lineNum');
					var mcNu = numm.getChildByName('bgNum');
					var n = numm.getChildByName('num');
				
					line.alpha = 0;
					n.htmlText = i+1;
					
					if(i == 0) {
						line.alpha = 1;
						numm.enabled = false;
						}
						
					numm.addEventListener(MouseEvent.ROLL_OVER, numOnRollOver);
					numm.addEventListener(MouseEvent.ROLL_OUT, numOnRollOut);
					numm.addEventListener(MouseEvent.CLICK, numOnClick);
					
					numConteiner.addChild(numm);
					}
					
				numConteiner.alpha = 0;
				addChild(numConteiner);
				TweenMax.to(numConteiner, .4, {alpha:1, delay:.8, ease:Sine.easeOut});
				
				alignNums();
				
				if(needNums == 1) {
					numConteiner.visible = false;
					}
				
			}
			
		private function removeNums():void {
			TweenMax.to(numConteiner, .5, {alpha:0, ease:Sine.easeOut, onComplete: removeNu});
			function removeNu():void {
				if(numConteiner) {
					removeChild(numConteiner);
					}
				}
			}	
			
		private function numOnRollOver(e:MouseEvent):void {
		
			if (e.target.enabled) {
				channelAnoser = rollOverSound.play(125);
				channelAnoser.soundTransform = new SoundTransform(.3, 0);
				e.target.useHandCursor = true;
				e.target.buttonMode = true;
				var line = e.target.getChildByName('lineNum');
				TweenMax.to(line, .2, {alpha:1, ease:Sine.easeOut});
			}
			
			}
			
		private function numOnRollOut(e:MouseEvent):void {
			
			e.target.useHandCursor = false;
			e.target.buttonMode = false;
			
			if (e.target.enabled) {
			var line = e.target.getChildByName('lineNum');
			TweenMax.to(line, .2, {alpha:0, ease:Sine.easeOut});
			}
				
			}
			
		private function numOnClick(e:MouseEvent):void {
			
			if (e.target.parent.enabled) { 
				
				channelAnoser = clickItem.play(95);
				channelAnoser.soundTransform = new SoundTransform(.7, 0);
			
				for (var i=0; i<numConteiner.numChildren; i++) {
					var thisB = numConteiner.getChildAt(i)
					thisB.enabled = true;
					TweenMax.to(thisB.getChildByName('lineNum'), .2, {alpha:0, ease:Sine.easeOut});
					if (e.target.parent.name == i) {
						e.target.parent.enabled = false;
						TweenMax.to(e.target.parent.getChildByName('lineNum'), .2, {alpha:1, ease:Sine.easeOut});
						removeItems(i);
						}
					}
				}
			}
			
		private function removeItems(n:Number):void {
			nCount = n;
			enterCount = 0;
			addEventListener(Event.ENTER_FRAME, removeEnterFrame);
			}
			
		private function removeEnterFrame(e:Event):void {
			
			if(enterCount<holderGallery.numChildren) {
				var getRandom:Number = Math.random()/2;
				var remObject = holderGallery.getChildAt(enterCount);
				TweenMax.to(remObject, .4, {y:remObject.y-stage.stageHeight, delay:getRandom, ease:Sine.easeOut});
				remObject.addEventListener(Event.ENTER_FRAME, listObject);
				}
				else  {
					if(holderGallery.numChildren == 0){
						removeEventListener(Event.ENTER_FRAME, removeEnterFrame);
						}
					enterCount = -1;
					}
					
			enterCount++;
			
			}
			
		private function listObject(e:Event):void {
			if(e.target.y+e.target.height+10<-100) {
				
				e.target.removeEventListener(MouseEvent.ROLL_OVER, onItemRollOver);
				e.target.removeEventListener(MouseEvent.ROLL_OUT, onItemRollOut);
				e.target.removeEventListener(Event.ENTER_FRAME, listObject);
				e.target.parent.removeChild(DisplayObject(e.target));
				
				if(holderGallery.numChildren == 0 ) {
					//removeChild(holderGallery);
					
					if(numConteiner) {
						numCreated = true;
						}
						
					if(portBool){
						nCount = 0;
						numCreated = false;
						portBool = false;
						}
					
					enterCount = 0;
					getPoints();
					createItems();
					}
				
					
				}
				
				
			}	
			
		private function alignNums():void {
			if(numConteiner){
				numConteiner.x = pointAr[0].x - 180/2;
				numConteiner.y = pointAr[0].y+(135+135/2)+5;
				}
			}	
			
		private function onStageResize(e:Event): void {
			getPoints();
			alignNums();
			alignMusic();
			alignFull();
			
			topMenu.x = (stage.stageWidth - topMenu.width)/2;
			
			if(loadB) {
			loadB.x = stage.stageWidth/2;
			loadB.y = stage.stageHeight/2-120;
			}
			
			for (var i = 0; i<holderGallery.numChildren; i++) {
				var objThis = holderGallery.getChildAt(i);
				objThis.x = pointAr[i].x;
				objThis.y = pointAr[i].y;
				}
			}	
			
			
	}
}