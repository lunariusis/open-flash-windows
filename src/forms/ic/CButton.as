package forms.ic 
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
	import forms.Form;
	
	/**
	 * ...
	 * @author Kalarashan
	 */
	public class CButton extends Sprite 
	{
		private var interactiveText:String = "";
		private var labelTF:TextField;
		public var radioSetOn:Boolean = true;
		private var fadeTime:Number = 0.2;
		private var b_up:Sprite;
		private var b_over:Sprite;
		private var b_down:Sprite;
		private var b_fon:Sprite;
		
		public function CButton() 
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
		
		public function reinit():void
		{
			getButtonLayers(this);
		}
		
		private function controlAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
			//
			init();
		}
		
		
		private function init():void 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDownMe);
			this.addEventListener(MouseEvent.MOUSE_OVER, onOverMe);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOutMe);
			this.addEventListener(MouseEvent.MOUSE_UP, onUpMe);
			this.mouseChildren = true;
			this.mouseEnabled = true;
			//
			addTextLabel();
			getButtonLayers(this);
		}

		
		
		private function onDownMe(event:MouseEvent):void 
		{
			Tweener.addTween(b_over, { alpha:0, onComplete:null, time:fadeTime, transition:"linear" } );
			Tweener.addTween(b_up, { alpha:0, onComplete:null, time:fadeTime, transition:"linear" } );
		}
		
		
		
		private function onUpMe(event:MouseEvent):void 
		{
			Tweener.addTween(b_over, { alpha:1, onComplete:null, time:fadeTime, transition:"linear" } );
			Tweener.addTween(b_up, { alpha:1, onComplete:null, time:fadeTime, transition:"linear" } );
		}
		
		
		private function onOverMe(event:MouseEvent):void 
		{
			Tweener.addTween(b_up, { alpha:0, onComplete:null, time:fadeTime, transition:"linear" } );
		}
			
		private function onOutMe(event:MouseEvent):void 
		{
			Tweener.addTween(b_up, { alpha:1, onComplete:null, time:fadeTime, transition:"linear" } );
		}
		
		private function getButtonLayers(cs:*):void
		{
			var layer:String;
			for (var i:int = 0; i < cs.numChildren; i++) 
			{
				layer = cs.getChildAt(i).name;
				if (layer.indexOf("_up") >= 0) 		{ b_up = cs.getChildByName(layer) as Sprite }
				if (layer.indexOf("_over") >= 0) 	{ b_over = cs.getChildByName(layer) as Sprite}
				if (layer.indexOf("_down") >= 0) 	{ b_down = cs.getChildByName(layer) as Sprite}
				if (layer.indexOf("_fon") >= 0) 	{ b_fon = cs.getChildByName(layer) as Sprite}
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
	}

}