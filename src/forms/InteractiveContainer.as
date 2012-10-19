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

		}
		
	}

}