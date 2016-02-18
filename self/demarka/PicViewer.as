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

	public class PicViewer extends Sprite {
		
		private var sourseBit:Bitmap;
		private var colX:Number = 6;
		private var colY:Number = 5;
		private var picHolder:Sprite = new Sprite();
		private var colorB:String;
		
		private var closeB:Sprite;
		private var closeR:Object;
		private var closeL:Object;
		private var closeT:Object;
		
		private var sArray:Array;
		private var pointA:Array;
		
		private var enterCout:Number;
		
		//sounds
		private var beginReverse:Sound;
		private var clickItem:Sound;
		private var menuClick:Sound;
		private var buildOn:Sound;
		private var channelAnoser:SoundChannel = new SoundChannel();
		
		public function PicViewer(bit:Bitmap, c:String) {
	
			this.sourseBit = bit;
			this.enterCout = 0;
			this.colorB = c;
			this.addEventListener(Event.ADDED_TO_STAGE, picOnAdd);
			
			channelAnoser.soundTransform = new SoundTransform(.2, 0);
			//channelAnoser =beginReverse.play();
			//channelAnoser.soundTransform = new SoundTransform(.2, 0);
			this.beginReverse = new reverseBegin();
			this.clickItem = new clickItems();
			this.buildOn = new onBuild();
			this.menuClick = new clickMenu();
			
		}
		
		private function picOnAdd(e:Event):void {
			
			sliceSourceBit();
			disableClicks();
			
			addChild(picHolder);
			picHolder.x = -200;
			picHolder.mouseEnabled = false;
			
			TweenMax.to(picHolder, .1, {dropShadowFilter:{alpha:.3, angle:45, blurX:10, blurY:10, distance:0, strength:1}});  
			
			getCloseB();
			
			addEventListener(Event.ENTER_FRAME, onPicsEnter);
			stage.addEventListener(Event.RESIZE, onThisResize);
			
			channelAnoser = buildOn.play();
			channelAnoser.soundTransform = new SoundTransform(.6, 0);
			}	
		
		private function sliceSourceBit():void {
	
			var bd:BitmapData = new BitmapData(sourseBit.width, sourseBit.height);
			bd.draw(sourseBit);
			
			var thisW = sourseBit.width/colX;
			var thisH = sourseBit.height/colY;
			
			sArray = [];
			pointA = [];
			
			for (var j=0; j<colY; j++) {
				for(var i=0; i<colX; i++) {
					var rect = new Rectangle(thisW*i,thisH*j,thisW,thisH);
					var point = new Point (0,0);
					var sliceBit:BitmapData = new BitmapData(thisW, thisH);
					var cloneBd = bd.clone();
					sliceBit.copyPixels(cloneBd,rect,point);
					sArray.push(new Bitmap(sliceBit));
					pointA.push(new Point(thisW*i,thisH*j));
					}
				}
			
			//var d = addChild(sArray[2])
			//d.x = 100;
			//TweenMax.to(d, .2, {colorMatrixFilter:{colorize:"0x00CCFF",brightness:.8}});
			}
			
		private function onPicsEnter(e:Event):void {
			if (enterCout<sArray.length) {
				var getRandom:Number = Math.random()/2;
				TweenMax.to(sArray[enterCout], .4, {x:pointA[enterCout].x,y:pointA[enterCout].y, delay:getRandom, ease:Sine.easeOut});
				TweenMax.to(picHolder, .3, {x:(stage.stageWidth - picHolder.width)/2,y:(stage.stageHeight - picHolder.height)/2});
				picHolder.addChild(sArray[enterCout]);
				}
				else {
					TweenMax.to(picHolder, .4, {x:(stage.stageWidth - picHolder.width)/2,y:(stage.stageHeight - picHolder.height)/2, ease:Sine.easeOut, onComplete:onEndAlign});
					function onEndAlign():void {
						removeEventListener(Event.ENTER_FRAME, onPicsEnter);
						enterCout = 0;
						}
					}
				
				enterCout++
			}
			
		private function onThisResize(e:Event):void {
			if(picHolder){
			picHolder.x = (stage.stageWidth - picHolder.width)/2;
			picHolder.y = (stage.stageHeight - picHolder.height)/2;
			}
			
			
			if(getChildByName('dis')){
				var d = getChildByName('dis');
				d.width = stage.stageWidth;
				d.height = stage.stageHeight;
				}
			}
			
		private function disableClicks():void {
			var dis = new Sprite();
			dis.name = 'dis';
			dis.graphics.beginFill(0x000,1)
			dis.graphics.drawRect(0,0,100,100);
			dis.width = stage.stageWidth;
			dis.height = stage.stageHeight;
			dis.alpha = 0;
			
			dis.useHandCursor = true;
			dis.buttonMode = true;
			
			Mouse.hide();
			addChild(dis)
			
			TweenMax.to(dis, .2, {alpha:.2, ease:Sine.easeOut});
			dis.addEventListener(MouseEvent.CLICK, onClickFon);
			}
			
		private function onClickFon(e:MouseEvent):void {
			enterCout = 0;
			
			channelAnoser = clickItem.play(95);
			channelAnoser.soundTransform = new SoundTransform(.7, 0);
			
			e.target.removeEventListener(MouseEvent.CLICK, onClickFon);
			addEventListener(Event.ENTER_FRAME, removeEnter);
			}	
			
		private function getCloseB():void {
			
			closeB = new closeBut();
			closeB.x = -200;
			
			closeR = closeB.getChildByName('rClose');
			closeT = closeB.getChildByName('tClose');
			
			closeT.alpha = 0;
			closeB.mouseEnabled = false;
			closeR.mouseEnabled = false;
			
			addEventListener(MouseEvent.MOUSE_MOVE, onMouseM);
			addChild(closeB);
			}
			
		private function onMouseM(e:MouseEvent):void {
			TweenMax.to(closeB, .2, {x:mouseX,y:mouseY, ease:Sine.easeOut});
			TweenMax.to(closeR, .8, {rotation:360, ease:Sine.easeOut});
			TweenMax.to(closeT, .2, {alpha:1, ease:Sine.easeOut});
			
			}
			
		private function removeEnter(e:Event):void {
			if (enterCout<sArray.length) {
				
				var getRandom:Number = Math.random()/2;
				var thisObj = sArray[enterCout];
				TweenMax.to(thisObj, .4, {x:sArray[0].x,y:sArray[0].y, delay:getRandom, ease:Sine.easeOut});
				TweenMax.to(picHolder, .3, {x:(stage.stageWidth-sArray[0].width)/2,y:(stage.stageHeight-sArray[0].height)/2});

			}
			else {
				 
				 channelAnoser = beginReverse.play();
				 channelAnoser.soundTransform = new SoundTransform(1, 0);
				 
				 removeEventListener(Event.ENTER_FRAME, removeEnter);
				 
				 var fon = getChildByName('dis');
				 TweenMax.to(picHolder, .5, {alpha:0, ease:Sine.easeOut,onCompleteListener:removeALL});
				 TweenMax.to(closeB, .2, {alpha:0, ease:Sine.easeOut});
				 TweenMax.to(fon, .2, {alpha:0, ease:Sine.easeOut});
				 
				 function removeALL($e:TweenEvent):void {
					dispatchRemove();
				 	}
				
				}
				
			enterCout++
			
			}
			
	private function dispatchRemove():void {
		Mouse.show();
		stage.removeEventListener(Event.RESIZE, onThisResize);
		dispatchEvent(new Event('removePicBig'));	
		
		}		
			
	}
}