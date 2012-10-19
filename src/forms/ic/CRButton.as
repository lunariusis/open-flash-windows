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
	public class CRButton extends Sprite 
	{
		private var interactiveText:String = "";
		private var labelTF:TextField;
		private var radio_on:Sprite;
		private var radio_off:Sprite;
		private var radio_fon:Sprite;
		public var radio_checked:Boolean = true;
		
		public function CRButton() 
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			this.addEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
		}
	
		private function controlRemoveMe(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			while (this.numChildren) { this.removeChildAt(0); }
			//
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onDownRadio);
		}
		
		private function controlAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
			//
			init();
		}
		
		private function init():void 
		{
			this.addEventListener(MouseEvent.MOUSE_DOWN, onDownRadio);
			//
			getRadioLayers();
		}
		
		public function reinit():void
		{
			getRadioLayers();
		}

		private function onDownRadio(event:MouseEvent):void 
		{
			
			radio_on.visible = !radio_on.visible;
			radio_checked = radio_on.visible;
		}
		
		public function set checked(s:Boolean):void
		{
			radio_checked = s;
			radio_on.visible = radio_checked;
		}
		
		public function get checked():Boolean
		{
			return radio_checked;
		}
		
		private function getRadioLayers():void
		{ 
			var layer:String;
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				layer = this.getChildAt(i).name;
				if (layer.indexOf("radio_on") >= 0) 	{ radio_on  = getChildByName(layer) as Sprite}
				if (layer.indexOf("radio_off") >= 0) 	{ radio_off = getChildByName(layer) as Sprite}
				if (layer.indexOf("radio_fon") >= 0) 	{ radio_fon = getChildByName(layer) as Sprite}
			}
		}
		
		
	}

}