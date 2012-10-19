package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Alexander Kalarashan
	 */
	public class Main extends Sprite 
	{
		private var MM:MainMenuController;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			addMainMenu();
		}
		
		public function addMainMenu():void
		{
			MM = new MainMenuController();
			this.addChild(MM);
		}
		
		
	}
	
}