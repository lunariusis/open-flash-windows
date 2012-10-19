package  
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import forms.Form;
	import forms.ic.CButton;
	import forms.ic.CRButton;
	import forms.ic.CSlider;
	import forms.InteractiveContainer;
	
	/**
	 * ...
	 * @author Alexander Kalarashan
	 */
	public class MainMenuController extends Sprite 
	{
		
		private var mainMenuForm:Form;
		private var optionsForm:Form;
		
		[Embed(source = "../lib/forms/MainMenu.xml", mimeType = "application/octet-stream")] public static var MainMenuXMLClass:Class;
		[Embed(source = "../lib/forms/OptionsWindow.xml", mimeType = "application/octet-stream")] public static var OptionsWindowXMLClass:Class;
		
		public function MainMenuController() 
		{
			this.addEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			this.addEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
		}
		
		private function controlAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
			addForms();
		}
		
		private function controlRemoveMe(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
		}
		
		private function addForms():void 
		{
			mainMenuForm = new Form(MainMenuXMLClass, "MainMenu", onLoadMainMenu, true);
			this.addChild(mainMenuForm);
			optionsForm = new Form(OptionsWindowXMLClass, "OptionsWindow", onLoadOptionsWindow, true);
			this.addChild(optionsForm);
		}
		
		private	function onLoadMainMenu():void 
		{
			var startButton:CButton = mainMenuForm.getChildren("button_set_1", CButton);
			startButton.setTextLabel("START", 35);
			startButton.addEventListener(MouseEvent.CLICK, onClickOk);
			function onClickOk(e:MouseEvent):void 
			{
				startButton.removeEventListener(MouseEvent.CLICK, onClickOk);
				mainMenuForm.removeForm(removeMe);
				mainMenuForm = null;
			}
		}
		
		private	function onLoadOptionsWindow():void 
		{
			optionsForm.addBlockFon(0xBF6000, 0.3);
			optionsForm.addTextContainer("textmarker_options_header", "TEST");
			var okButton:CButton = optionsForm.getChildren("button_set_1", CButton);
			okButton.addEventListener(MouseEvent.CLICK, onClickOk);
			function onClickOk(e:MouseEvent):void 
			{
				okButton.removeEventListener(MouseEvent.CLICK, onClickOk);
				optionsForm.removeForm();
				optionsForm = null;
			}
			(optionsForm.getChildren("radio_set_full_screen", CRButton) as CRButton).checked = false;
			
			
			var slider1:CSlider = optionsForm.getChildren("slider_set_sound_effects", CSlider);
			slider1.sliderValue = 0;
			slider1.debug = true;
			
			var slider2:CSlider = optionsForm.getChildren("slider_set_music", CSlider);
			slider2.sliderValue = 50;
			slider2.debug = true;
			slider2.up_reaction = true;
			
			var slider3:CSlider = optionsForm.getChildren("slider_set_ambient_sounds", CSlider);
			slider3.sliderValue = 100;
			slider3.debug = true;
			
		}
		
		public function removeMe():void
		{
			while (this.numChildren)
			{
				try { ((this.getChildAt(0) as Sprite).getChildAt(0) as Bitmap).bitmapData.dispose(); } catch (error:*) { this.removeChildAt(0); continue; }
				this.removeChildAt(0);
			}
			mainMenuForm = null;
			optionsForm = null;
			(this.parent as Main).addMainMenu();
			this.parent.removeChild(this);
		}
	}

}