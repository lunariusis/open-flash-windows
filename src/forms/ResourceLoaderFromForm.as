package forms 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Kalarashan Alexander
	 */
	public class ResourceLoaderFromForm 
	{
		private var imagesArrayForDispose:Array = [];
		
		public function disposeImages(formName:String):void
		{
			if (imagesArrayForDispose == null) { return }
			for (var i:int = 0; i < imagesArrayForDispose.length; i++) 
			{
				
				if ( String(imagesArrayForDispose[i]).indexOf(formName) >= 0)
				{
					imagesArrayForDispose[i].dispose();
					imagesArrayForDispose[i] = null;
					imagesArrayForDispose = imagesArrayForDispose.slice(0, i).concat(imagesArrayForDispose.slice(i + 1, imagesArrayForDispose.length));
					--i;
				}
			}
		}
		
		public function loadResourceURL(urls:Array, parent_container:Sprite, callback:Function = null, inLibrary:Boolean = false):void
		{
			if (!inLibrary) // грузим из файлов
			{	
				var counter:Number = 0;
				var count:Number = urls.length;
				var loaderImage:Loader = new Loader();
				loaderImage.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteLoadImage);
				loaderImage.load(new URLRequest(urls[0].url));
				
				function onCompleteLoadImage(event:Event):void 
				{	
					var image:Bitmap = event.currentTarget.content;
					var sprite:Sprite = urls[0].container;
					var imageSprite:Sprite = new Sprite();
					imageSprite.name = urls[0].name;
					imageSprite.x = urls[0].x;
					imageSprite.y = urls[0].y;
					imageSprite.addChild(image);
					//
					imageSprite.mouseChildren = false;
					imageSprite.mouseEnabled = false;
					//
					if (sprite != parent_container)
					{
						sprite.addChild(imageSprite);
						parent_container.addChild( sprite );
					}
					else
					{
						parent_container.addChild( imageSprite );
						imageSprite.mouseChildren = false;
						imageSprite.mouseEnabled = false;
					}
					
					urls.shift();
					counter += 1;
					
					if (urls.length > 0)
					{
						loaderImage.load(new URLRequest(urls[0].url));
					}
					else
					{
						loaderImage = null;
					}
					
					if (counter >= count && callback != null)
					{
						callback();
					}
					
				}
			}
			else // грузим из библиотеки
			{
				for (var i:int = 0; i < urls.length; i++) 
				{
					var ar:Array = urls[i].url.split("/");
					var nameBitmap:String = ar[1] + "_" + ar[2].split(".")[0];
					var image:Bitmap = getBitmap(nameBitmap);
					//
					var sprite:Sprite = urls[i].container;
					var imageSprite:Sprite = new Sprite();
					imageSprite.name = urls[i].name;
					imageSprite.x = urls[i].x;
					imageSprite.y = urls[i].y;
					imageSprite.addChild(image);
					//
					imageSprite.mouseChildren = false;
					imageSprite.mouseEnabled = false;
					
					if (sprite != parent_container)
					{
						sprite.addChild(imageSprite);
						parent_container.addChild( sprite );
					}
					else
					{
						parent_container.addChild( imageSprite );
						imageSprite.mouseChildren = false;
						imageSprite.mouseEnabled = false;
					}
					image = null;
				}
				if (callback != null)
				{
					callback();
				}
			}
		}
		
		private function getBitmap(name:String):Bitmap
		{	
			var img_c:Class = getDefinitionByName(name) as Class;
			var img_1:BitmapData = new img_c();
			imagesArrayForDispose.push(img_1);
			var image:Bitmap = new  Bitmap(img_1);
			image.smoothing = true;
			image.name = name;
			img_c = null;
			img_1 = null;
			return image;
		}
		
		private function getSprite(name:String, center:Boolean = false):Sprite
		{	
			var img_c:Class = getDefinitionByName(name) as Class;
			var img_1:BitmapData = new img_c();
			var image_mc:Sprite = new Sprite();
			var image:Bitmap = new  Bitmap(img_1)
			if (center == true)
			{
				var i_width:Number = image.width/2
				var i_height:Number = image.height/2
				image.x = -i_width;
				image.y = -i_height;
			}
			image.smoothing = true;
			image.name = name;
			image_mc.addChild(image);
			return image_mc;
		}
	}

}