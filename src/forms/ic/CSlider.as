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
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import forms.Form;
	
	/**
	 * ...
	 * @author Kalarashan
	 */
	public class CSlider extends Sprite 
	{
		private var interactiveText:String = "";
		private var labelTF:TextField;
		public var radioSetOn:Boolean = true;
		private var fadeTime:Number = 0.2;
		private var slider_button:Sprite;
		private var slider_line:Sprite;
		private var slider_fon:Sprite;
		private var slider_line_width_new:Number;
		//
		public var slider_value:int = 0;
		public var slider_line_offset:Number = 5;
		public var magicNumber_1:Number = 1.17;
		public var up_reaction:Boolean = false;
		public var debug:Boolean = false;
		
		public function CSlider() 
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			this.addEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
		}
	
		private function controlRemoveMe(event:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			while (this.numChildren) { this.removeChildAt(0); }
			//
		
			slider_button.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderButtonDown);
			slider_button.removeEventListener(MouseEvent.MOUSE_UP, onSliderButtonUp);
			slider_line.removeEventListener(MouseEvent.MOUSE_DOWN, onSliderLineDown);
			slider_button.removeEventListener(MouseEvent.RELEASE_OUTSIDE, onSliderButtonUp);
			this.removeEventListener(MouseEvent.MOUSE_UP, onSliderUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onSliderMouseMove);
		}
		
		private function controlAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
			//
			init();
		}
		
		private function init():void 
		{
			getSliderLayers();
		}
		
		
		public function reinit():void
		{
			getSliderLayers();
			slider_line_width_new = slider_line.width - slider_line_offset * 2;
			slider_button.mouseEnabled = true;
			slider_line.mouseEnabled = true;
			slider_button.addEventListener(MouseEvent.MOUSE_DOWN, onSliderButtonDown);
			slider_button.addEventListener(MouseEvent.MOUSE_UP, onSliderButtonUp);
			slider_button.addEventListener(MouseEvent.RELEASE_OUTSIDE, onSliderButtonUp);
			slider_line.addEventListener(MouseEvent.MOUSE_DOWN, onSliderLineDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onSliderUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onSliderMouseMove);
		}
		
		private function onSliderUp(e:MouseEvent):void 
		{
			if (up_reaction)
			{
				//TODO reaction of UP mouse, example - play sound.
				resetValue();
				if (debug) trace(slider_value);
			}
		}
		
		private function onSliderMouseMove(e:MouseEvent):void 
		{
			e.updateAfterEvent();
			if (e.buttonDown && !up_reaction)
			{
				resetValue();
				if (debug) trace(slider_value);
			}
		}
		
		private function resetValue():void
		{
			//TODO it is MAGIC
			slider_value = ((slider_button.x - slider_line_offset)  * 100 / (slider_line_width_new)) * magicNumber_1;
		}
		
		private function refreshSlider():void 
		{
			//TODO it is MAGIC
			slider_button.x = ( ( ( slider_value - slider_line_offset ) * slider_line_width_new / 100) / magicNumber_1) + slider_button.width/3
		}
		
		private function onSliderButtonUp(e:MouseEvent):void 
		{
			slider_button.stopDrag();
			resetValue();
			if (debug) trace(slider_value);
		}
		
		private function onSliderButtonDown(e:MouseEvent):void 
		{
			//TODO it is MAGIC
			var slider_button_xslide_max:Number = slider_line.width - slider_line_offset * 2 - slider_button.width / 2;
			slider_button.startDrag(false, new Rectangle(slider_line_offset, 0, slider_button_xslide_max, 0));
		}
		
		private function onSliderLineDown(e:MouseEvent):void 
		{
			//TODO it is MAGIC
			if (mouseX >= slider_line_offset + slider_line_width_new)
			{
				slider_button.x = (slider_line_offset + slider_line_width_new) - slider_button.width/2;
			}
			else if (mouseX <= slider_line_offset + slider_button.width)
			{
				slider_button.x = slider_line_offset
			}
			else
			{
				slider_button.x = mouseX - slider_button.width/2;
			}
		}
		
		
		public function set sliderValue(s:int):void
		{
			slider_value = s;
			refreshSlider();
		}
		
		public function get sliderValue():int
		{
			return slider_value;
		}
		
		private function getSliderLayers():void
		{ 
			var layer:String;
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				layer = this.getChildAt(i).name;
				if (layer.indexOf("slider_button") >= 0) 	{ slider_button  = getChildByName(layer) as Sprite}
				if (layer.indexOf("slider_line") >= 0) 		{ slider_line = getChildByName(layer) as Sprite}
				if (layer.indexOf("slider_fon") >= 0) 		{ slider_fon = getChildByName(layer) as Sprite}
			}
		}
		
	}

}