package forms 
{
	import caurina.transitions.Tweener;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import forms.ic.CButton;
	import forms.ic.CRButton;
	import forms.ic.CSlider;
	
	/**
	 * ...
	 * @author Kalarashan
	 */
	public class Form extends Sprite 
	{
		public static const debug:Boolean = false;
		//
		private var images:Array = [];
		private var interactive_container:Sprite;
		private var _callback:Function;
		private var _xmlURL:Class;
		private var blockFon:Sprite;
		private var _inLibrary:Boolean;
		private var _nameForm:String;
		//
		private var sWidth:int = 640;
		private var sHeight:int = 480;		
		//
		private var textMArkersArray:Array = []
		private var RL:ResourceLoaderFromForm;
		
		/**
		 * 
		 * @param	xmlURL		путь к XML файлу формы
		 * @param	callback	функция вызываемая после готовности формы
		 */
		public function Form( xmlURL:Class, nameForm:String, callback:Function = null, inLibrary:Boolean = true ) 
		{
			_xmlURL = xmlURL;
			_nameForm = nameForm;
			_callback = callback;
			_inLibrary = inLibrary;
			this.name = nameForm;
			this.visible = false;
			//
			this.addEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			this.addEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);
			//
			RL = new ResourceLoaderFromForm();
			
		}
		/**
		 * обработка удаления формы
		 * @param	event
		 */
		private function controlRemoveMe(event:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, controlRemoveMe);
			//
			RL.disposeImages(_nameForm);
			while (this.numChildren)
			{ 
				try { ((this.getChildAt(0) as Sprite).getChildAt(0) as Bitmap).bitmapData.dispose(); } catch (error:*) { this.removeChildAt(0); continue; }
				this.removeChildAt(0); 
			}
			RL = null;
			_callback = null;
			GarbageCollector.force();
		}
		
		/**
		 * обработка добавления на сцену
		 * @param	event
		 */
		private function controlAddedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, controlAddedToStage);			
			if (this.parent.getChildByName(_nameForm) && this.parent.getChildByName(_nameForm) != this)
			{
				trace("duplicate form name:" , _nameForm);
				return;
			}
			//
			sWidth = this.stage.stageWidth;
			sHeight = this.stage.stageHeight;
			this.visible = false;
			this.parent.setChildIndex(this, this.parent.numChildren - 1);
			
			if (_inLibrary)
			{
				formDataXMLloader();
			}
			else
			{
				loadXML("forms/" + _nameForm + ".xml", test)
			}
			
			function test(data:*):void
			{
				formDataXMLloader(data)
			}
		}
		
		/**
		 * загрузка XML формы
		 */
		private function formDataXMLloader(data:* = null):void
		{
			var layersXML:XML
			if (data == null)
			{
				layersXML = new XML(new _xmlURL());
			}
			else
			{
				layersXML = new XML(data);
			}
			
			var lar:XMLList = layersXML.layer;
			var textContainer:Sprite;
			for (var i:String in lar)
			{
				if ( String(lar[i].@tp) == "L" && String(lar[i].@name).indexOf("textmarker_") == -1 )
				{
					images.push( { url:'forms/' + _nameForm + '/' + String(lar[i].@name) + '.png', x:int(lar[i].@x), y:int(lar[i].@y), name:String(lar[i].@name), altname:String(lar[i].@altname), container:this }  );
				}
				
				if (String(lar[i].@name).indexOf("textmarker_")>=0)
				{
					textContainer = new Sprite();
					textContainer.graphics.beginFill(0xFF0000, 0.4);
					textContainer.graphics.drawRect(0, 0, int(lar[i].@w), int(lar[i].@h))
					textContainer.graphics.endFill()
					textContainer.x = int(lar[i].@x);
					textContainer.y = int(lar[i].@y);
					textContainer.width = int(lar[i].@w);
					textContainer.height = int(lar[i].@h);
					textContainer.name = String(lar[i].@name);
					textMArkersArray.push([textContainer]);
				}
				
				if ( String(lar[i].@tp) == "LS" )
				{					
					var lars:XMLList = lar[i].layer;
					
					if (lar[i].@name.indexOf("button_") >= 0)
					{
						interactive_container = new CButton();
					}
					else if (lar[i].@name.indexOf("radio_") >= 0)
					{
						interactive_container = new CRButton();
					}
					else if (lar[i].@name.indexOf("slider_") >= 0)
					{
						interactive_container = new CSlider();
					}
					else
					{
						interactive_container = new InteractiveContainer();
					}
					interactive_container.x = int(lar[i].@x);
					interactive_container.y = int(lar[i].@y);
					interactive_container.name = String(lar[i].@name);
					for (var w:String in lars)
					{
						if (String(lars[w].@name).indexOf("textmarker_")>=0)
						{
							textContainer = new Sprite();
							textContainer.graphics.beginFill(0xFF0000, 0.4);
							textContainer.graphics.drawRect(0, 0, int(lars[w].@w), int(lars[w].@h))
							textContainer.graphics.endFill()
							textContainer.x = int(lars[w].@x);
							textContainer.y = int(lars[w].@y);
							textContainer.width = int(lars[w].@w);
							textContainer.height = int(lars[w].@h);
							textContainer.name = String(lars[w].@name);
							textMArkersArray.push([textContainer, interactive_container]);
						}
						else
						{
							images.push( { url:'forms/' + _nameForm + '/' + String(lars[w].@name) + '.png', x:int(lars[w].@x), y:int(lars[w].@y), name:String(lars[w].@name), altname:String(lars[w].@altname), container:interactive_container }  );
						}
					}
				}
			}
			lar = null;
			lars = null;
			System.disposeXML(layersXML);
			layersXML = null;
			interactive_container = null;
			renderForm();
		}
		
		
		/**
		 * Загрузка картинок и формирование интерфейса и интерактивных контейнеров
		 */
		public function renderForm():void
		{	
			RL.loadResourceURL(images, this, showForm, _inLibrary);
			images = [];
			images = null;
		}
		
		/**
		 * Возвращает элемент интерфейса с указанием его класса
		 * @param	name
		 * @param	classType
		 * @return
		 */
		public function getChildren(name:String, classType:Class):*
		{
			return this.getChildByName(name) as classType;
		}
		
		/**
		 * Показ формы после того как она будет готова
		 */
		private function showForm():void
		{
			
			for (var j:int = 0; j < textMArkersArray.length; j++) 
			{
				if (textMArkersArray[j].length == 1)
				{
					this.addChild(textMArkersArray[j][0]);
				}
				else
				{
					textMArkersArray[j][1].addChild(textMArkersArray[j][0]);
				}
			}
			textMArkersArray = [];
			textMArkersArray = null;
			
			
			for (var i:int = 0; i < this.numChildren; i++) 
			{
				try{ (this.getChildAt(i) as InteractiveContainer).reinit(); }catch (err:Error) {}
				try{ (this.getChildAt(i) as CButton).reinit(); }catch (err:Error) {}
				try{ (this.getChildAt(i) as CRButton).reinit(); }catch (err:Error) {}
				try{ (this.getChildAt(i) as CSlider).reinit(); }catch (err:Error) {}
			}
			
			// TODO здесь можно дописывать появление формы с эффектами
			
			if (_callback != null)
			{
				this.visible = true;
				_callback();
				_callback = null;
			}
			
		}
		
		public function addBlockFon(blockFonColor:uint = 0x666666, alpha:Number = 0.9):void
		{
			blockFon = new Sprite();
			blockFon.x = x;
			blockFon.y = y;
			blockFon.name = "blockFon";
			blockFon.graphics.beginFill(blockFonColor, alpha);
			blockFon.graphics.drawRect(0, 0, sWidth, sHeight );
			blockFon.graphics.endFill();
			this.addChildAt(blockFon, 0);
		}
		
		/**
		 * Скрывание/удаление формы
		 * @param	toComplete
		 */
		public function removeForm(toComplete:Function = null):void
		{
			// TODO здесь можно дописывать удаление окна с эффектами
			
			if (blockFon && this.contains(blockFon)) this.removeChild(blockFon);
			this.parent.removeChild(this);
			if (toComplete != null) { toComplete(); }
			GarbageCollector.force();
		}
		
		public function addTextContainer(nameMarker:String, labeText:String, textSize:int = 17, textAlign:String = 'center', textColor:uint = 0xffffff, textGlowColor:uint = 0x000000):TextField
		{
			var textContainer:Sprite = this.getChildren(nameMarker, Sprite);
			var wh:Number = textContainer.width; 
			var hh:Number = textContainer.height; 
			while (textContainer.numChildren) { textContainer.removeChildAt(0); }
			var labelTF:TextField = new TextField();
			labelTF.wordWrap = labelTF.multiline = labelTF.embedFonts = true;
			labelTF.defaultTextFormat = new TextFormat('Verdana', textSize, textColor, null, null, null, null, null, textAlign);
			labelTF.antiAliasType = AntiAliasType.ADVANCED;
			labelTF.selectable = labelTF.mouseEnabled = false;
			labelTF.width = wh;
			labelTF.height = hh;
			labelTF.htmlText = labeText;
			labelTF.x = labelTF.y = 0;
			labelTF.name = nameMarker;
			labelTF.filters = [new GlowFilter(textGlowColor, 1, 6, 6, 2, 1, false, false)];
			textContainer.addChild(labelTF);
			////
			if (Form.debug)
			{
				labelTF.border = true; labelTF.borderColor = 0xffffff;
			}
			textContainer.graphics.clear();
			return labelTF;
		}
		
		private function loadXML(xmlUrl:String = "", callback:Function = null):void
		{
			var request_config:URLRequest;
			var loader_config:URLLoader = new URLLoader; 
			request_config = new URLRequest(xmlUrl);
			loader_config.load(request_config); 
			loader_config.addEventListener(Event.COMPLETE, onCompleteConfigLoad);
			request_config = null;
			
			function onCompleteConfigLoad(event:Event):void 
			{			
				var loader:URLLoader = event.target as URLLoader;
				if (loader != null) {
					if (callback != null) { callback(new XML(loader.data)); }
				}
				loader_config = null;
			}
		}
	}

}