package nl.jorisdormans.phantom2D.lightEffects 
{
	import flash.geom.Matrix;
	import flash.geom.Vector3D;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Shader;
	import flash.display.Sprite;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class LightEffectLayer extends Layer
	{
		public var lightSources:Vector.<LightSource>;
		public var light:Number;
		public var lightColor:uint;
		//private var _lightSprite:Sprite;
		private var _lightSprite2:Sprite;
		private var _lightBitmapData:BitmapData;
		private var _lightFilter:ShaderFilter;
		private var numberOfLights:int;
		private var targetLight:Number;
		private var changeSpeed:Number;
		
		[Embed(source = 'assets/lighteffect.pbj', mimeType = 'application/octet-stream')]
		
		private static const lightEffectKernel:Class;
		
		
		public function LightEffectLayer(width:int, height:int, light:Number = 0) 
		{
			super(width, height);
			this.layerWidth = width;
			this.layerHeight = height;
			lightSources = new Vector.<LightSource>();
			this.light = light;
			targetLight = light;
			changeSpeed = 0;
			lightColor = 0xffffff;
			//_lightSprite = new Sprite();
			var byteArray:ByteArray = new lightEffectKernel() as ByteArray;
			var shader:Shader = new Shader(byteArray); 
			_lightFilter = new ShaderFilter(shader);
			sprite.filters = [_lightFilter];
			//addChild(_lightSprite);
			
			_lightSprite2 = new Sprite();
			var _lightSpriteMask2:Sprite = new Sprite();
			_lightSpriteMask2.graphics.beginFill(0x000000);
			_lightSpriteMask2.graphics.drawRect(0, 0, width*0.1, height*0.1);
			_lightSpriteMask2.graphics.endFill();
			_lightSprite2.addChild(_lightSpriteMask2);
			_lightSprite2.mask = _lightSpriteMask2;
			//addChild(_lightSprite2);
			
			_lightBitmapData = new BitmapData(width * 0.1, height * 0.1, true);
			numberOfLights = 0;
			
			
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			var d:Number = MathUtil.clamp(targetLight - light, -changeSpeed * elapsedTime, changeSpeed * elapsedTime);
			if (d != 0) {
				light += d;
				gameScreen.sendMessage("lightChanged", { light: light } );
			}
		}
		
		override public function render(camera:Camera):void 
		{
			super.render(camera);
			gameScreen.game.prof.begin("light effect");
			var c:uint = DrawUtil.lerpColor(0x003300, lightColor, light);
			sprite.graphics.clear();
			sprite.graphics.beginFill(c);
			sprite.graphics.drawRect(0, 0, layerWidth, layerHeight);
			sprite.graphics.endFill();
			_lightSprite2.graphics.clear();
			_lightSprite2.graphics.beginFill(c);
			_lightSprite2.graphics.drawRect(0, 0, layerWidth*0.1, layerHeight*0.1);
			_lightSprite2.graphics.endFill();
			for (var p:Number = Math.ceil(light*4)/4; p <= 1; p+=0.25) {
				for (var i:int = 0; i < numberOfLights; i++) {
					lightSources[i].draw(sprite.graphics, _lightSprite2.graphics, p);
				}
			}
			
			_lightBitmapData.draw(_lightSprite2);
			numberOfLights = 0;
			
			gameScreen.game.prof.end("light effect");	
		}
		
		public function addLightSource(x:Number, y:Number, radius:Number, strength:Number = 1, color:uint = 0xffffff):void {
			if (light >= 1) return;
			if (x + radius<0||x-radius>layerWidth || y+radius<0 || y-radius>layerHeight) return;
			
			if (numberOfLights>=lightSources.length) {
				lightSources.push(new LightSource(x, y, radius, strength, color));
			} else {
				lightSources[numberOfLights].setLight(x, y, radius, strength, color);
			}
			numberOfLights++;
		}
		
		public function addPlayerLight(x:Number, y:Number, radius:Number, strength:Number = 0.25):void {
			if (light > strength) return;
			radius += (layerWidth*0.5 - radius) * light;
			//var strength:Number = 0.25;
			//trace(radius, strength);
			//strength = 1;
			var color:uint = 0xffffff;
			if (numberOfLights>=lightSources.length) {
				lightSources.push(new LightSource(x, y, radius, strength, color));
			} else {
				lightSources[numberOfLights].setLight(x, y, radius, strength, color);
			}
			numberOfLights++;
		}
		
		
		public function lightAt(x:Number, y:Number):Number {
			x -= gameScreen.camera.left;
			y -= gameScreen.camera.top;
			if (x < 0 || y < 0 || x >= layerWidth || y > layerHeight) return 0;
			var i:uint = _lightBitmapData.getPixel(x*0.1, y*0.1);
			return (i & 0x0000ff) / 255;
		}		
		
		override public function generateNewXML():XML 
		{
			var xml:XML = super.generateNewXML();
			xml.@light = "1.0";
			return xml;
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			xml.@light = light;
			return xml;
		}
		
		override public function readXML(xml:XML):void
		{
			super.readXML(xml);
			light = xml.@light;
			targetLight = light;
		}
		
		public function changeLight(target:Number, speed:Number):void {
			targetLight = target;
			changeSpeed = speed;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "changeLight":
					changeLight(data.target, data.speed);
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		public function setLight(light:Number):void 
		{
			if (this.light != light) {
				gameScreen.sendMessage("lightChanged", { light: light } );
				this.light = light;
			}
			targetLight = light;
			
		}
		
	}

}