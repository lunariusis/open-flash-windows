package forms 
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author Kalarashan
	 */
	public class InteractiveContainer extends Sprite 
	{
		private var interactiveText:String = "";
		private var labelTF:TextField;
		public var radioSetOn:Boolean = true;
		private var fadeTime:Number = 0.2;
		
		public function InteractiveContainer() 
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			this.addEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
		}
	
		private function controlRemoveMe(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			while (this.numChildren) { this.removeChildAt(0); }
			//
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onDownMe);
			this.removeEventListener(MouseEvent.MOUSE_OVER, onOverMe);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onOutMe);
			this.removeEventListener(MouseEvent.MOUSE_UP, onUpMe);
		}
		
		private function controlAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
			//
			init();
		}
		
		public function reinit():void
		{
		}
		
		private function init():void 
		{
			if (this.name.indexOf("button_") >= 0)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onDownMe);
				this.addEventListener(MouseEvent.MOUSE_OVER, onOverMe);
				this.addEventListener(MouseEvent.MOUSE_OUT, onOutMe);
				this.addEventListener(MouseEvent.MOUSE_UP, onUpMe);
				//
				addTextLabel();
			}
			
			if (this.name.indexOf("radio_") >= 0)
			{
				this.addEventListener(MouseEvent.MOUSE_DOWN, onDownRadio);
			}
		}
		
		private function onDownRadio(event:MouseEvent):void 
		{
			
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				if (this.getChildAt(i).name.indexOf("radio_on") >= 0)
				{
					this.getChildAt(i).visible = !this.getChildAt(i).visible;
					radioSetOn = this.getChildAt(i).visible;
				}
			}
		}
		
		public function radioOn():void
		{
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				if (this.getChildAt(i).name.indexOf("radio_on") >= 0)
				{
					this.getChildAt(i).visible = true;
					radioSetOn = true;
				}
			}
		}
		
		public function radioOff():void
		{
			
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				if (this.getChildAt(i).name.indexOf("radio_on") >= 0)
				{
					this.getChildAt(i).visible = false;
					radioSetOn = false;
				}
			}
		}
		
		private function addTextLabel():void
		{
			labelTF = new TextField();
			labelTF.wordWrap = labelTF.multiline = labelTF.embedFonts = true;
			labelTF.defaultTextFormat = new TextFormat('Verdana', 10, 0xffffff, null, null, null, null, null, 'center');
			labelTF.autoSize = TextFieldAutoSize.CENTER;
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.selectable = labelTF.mouseEnabled = false;
			labelTF.width = this.width;
			labelTF.height = this.height;
			labelTF.text = interactiveText;
			labelTF.x = this.width / 2 - labelTF.width / 2;
			labelTF.y = this.height / 2 - labelTF.height / 2 - 3;
			labelTF.name = "text_label";
			labelTF.filters = [new GlowFilter(0x000000, 0.5, 6, 6, 2, 1, false, false)];
			this.addChild(labelTF)
		}
		
		public function setTextLabel(txt:String, size:int = 10, wD:int = 10, hD:int = 10, xD:int = 0, yD:int = 3, index:int = 1, color:uint = 0xffffff, bolded:Boolean = false, glowF:Boolean = true ):void
		{
			this.setChildIndex(labelTF, this.numChildren - index);
			labelTF.defaultTextFormat = new TextFormat('Verdana', size, color, bolded, null, null, null, null, 'center');
			labelTF.width = this.width - wD;
			labelTF.height = this.height - hD;
			labelTF.x = this.width / 2 - labelTF.width / 2 - xD;
			labelTF.y = this.height / 2 - labelTF.height / 2 - yD;
			if (glowF == false ) { labelTF.filters = [];}
			//
			interactiveText = txt;
			labelTF.text = interactiveText;
			////
			if (Form.debug)
			{
				labelTF.border = true; labelTF.borderColor = 0xffffff;
			}
		}

		private function getButtonLayers(cs:*):Array
		{
			var b_up:Sprite;
			var b_over:Sprite;
			var b_down:Sprite;
			var b_fon:Sprite; 
			var layer:String;
			for (var i:int = 0; i < cs.numChildren; i++) 
			{
				layer = cs.getChildAt(i).name;
				if (layer.indexOf("_up") >= 0) 		{ b_up = cs.getChildByName(layer) }
				if (layer.indexOf("_over") >= 0) 	{ b_over = cs.getChildByName(layer)}
				if (layer.indexOf("_down") >= 0) 	{ b_down = cs.getChildByName(layer)}
				if (layer.indexOf("_fon") >= 0) 	{ b_fon = cs.getChildByName(layer)}
			}
			
			return [b_up, b_over, b_down, b_fon];
		}
		
		
		private function onDownMe(event:MouseEvent):void 
		{
			var cs:* = event.currentTarget;
			//var countElement:String = cs.name.split("_")[2];
			if (cs.name.indexOf("button_") >= 0)
			{	
				var layers:Array = getButtonLayers(cs);
				var b_up:Sprite = layers[0];
				var b_over:Sprite = layers[1];
				var b_down:Sprite = layers[2];
				var b_fon:Sprite = layers[3];
				Tweener.addTween(b_over, { alpha:0, onComplete:null, time:fadeTime, transition:"linear" } );
				Tweener.addTween(b_up, { alpha:0, onComplete:null, time:fadeTime, transition:"linear" } );
			}
		}
		
		
		
		private function onUpMe(event:MouseEvent):void 
		{
			var cs:* = event.currentTarget;
			if (cs.name.indexOf("button_") >= 0)
			{	
				var layers:Array = getButtonLayers(cs);
				var b_up:Sprite = layers[0];
				var b_over:Sprite = layers[1];
				var b_down:Sprite = layers[2];
				var b_fon:Sprite = layers[3];
				Tweener.addTween(b_over, { alpha:1, onComplete:null, time:fadeTime, transition:"linear" } );
				Tweener.addTween(b_up, { alpha:1, onComplete:null, time:fadeTime, transition:"linear" } );
			}
		}
		
		
		private function onOverMe(event:MouseEvent = null):void 
		{
			var cs:* = event.currentTarget;
			if (cs.name.indexOf("button_") >= 0)
			{	
				var layers:Array = getButtonLayers(cs);
				var b_up:Sprite = layers[0];
				var b_over:Sprite = layers[1];
				var b_down:Sprite = layers[2];
				var b_fon:Sprite = layers[3];
				Tweener.addTween(b_up, { alpha:0, onComplete:null, time:fadeTime, transition:"linear" } );
			}
		}
			
		private function onOutMe(event:MouseEvent = null):void 
		{
			var cs:* = event.currentTarget;
			if (cs.name.indexOf("button_") >= 0)
			{	
				var layers:Array = getButtonLayers(cs);
				var b_up:Sprite = layers[0];
				var b_over:Sprite = layers[1];
				var b_down:Sprite = layers[2];
				var b_fon:Sprite = layers[3];
				Tweener.addTween(b_up, { alpha:1, onComplete:null, time:fadeTime, transition:"linear" } );
			}
		}
	}

}