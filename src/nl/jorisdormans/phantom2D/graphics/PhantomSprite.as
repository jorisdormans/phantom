package nl.jorisdormans.phantom2D.graphics 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author ...
	 */
	public class PhantomSprite extends Component implements IRenderable
	{
		private const MAX_STACK:int = 32;
		private var data:BitmapData;
		private var width:Number;
		private var height:Number;
		private var mat:Matrix;
		
		//TODO:this can be improved with a data structure for the animation stack and a vector of a fixed length
		private var stack:Array = new Array();
		
		private var frameCount:Number;
		private var frame:Number;
		
		private var currentAnimation:String;
		
		private var imageWidth:Number;
		private var imageHeight:Number;
		private var framesX:int;
		private var framesY:int;
		private var fps:Number;
		private var timer:Number = 0;
		private var animationFrame:Number;
		private var animations:Dictionary;
		private var popTimer:Number;
		
		public var horizontalFlip:Boolean = false;
		public var verticalFlip:Boolean = false;
		
		public function PhantomSprite( img:Class, width:int, height:int, fps:Number=12 )
		{
			var inst:Bitmap = new img();
			
			this.data = inst.bitmapData;
			
			this.imageWidth = inst.width;
			this.imageHeight = inst.height;
			
			this.width = width;
			this.height = height;
			
			this.framesX = (this.imageWidth / this.width);
			this.framesY = (this.imageHeight / this.height);
			
			this.mat = new Matrix();
			this.mat.identity();
			
			this.frameCount = this.framesX * this.framesY;
			this.frame = 0;
			this.animationFrame = 0;
			this.fps = fps;
			
			this.currentAnimation = null;
			this.animations = new Dictionary();
		}
		
		public function addAnimation( name:String, ...frames ):void
		{
			var res:Vector.<int> = new Vector.<int>();
			
			for (var i:uint = 0; i < frames.length; i++)
				if( frames[i] is int )
					res.push( frames[i] );

			this.animations[name] = res;
		}
		
		public function pushAnimation( animation:String, count:int = 1, fps:Number = -1):String 
		{
			var old:String = this.currentAnimation;
			
			//push the current animation to the stack
			this.stack.push( { animation:this.currentAnimation, fps:this.fps, popTimer:this.popTimer, timer:this.timer, animationFrame: this.animationFrame } );
			//set the current animation
			this.currentAnimation = animation;
			if ( fps >= 0 )
				this.fps = fps;
			this.popTimer = this.animations[this.currentAnimation].length * count * 1.0 / this.fps;
			resetAnimation();
			
			return old;
		}
		
		public function playAnimation( animation:String, fps:Number = -1 ):String
		{
			var old:String = this.currentAnimation;
			this.stack.splice(0, stack.length);
			
			this.currentAnimation = animation;
			if ( fps >= 0 )
				this.fps = fps;
				
			if ( this.animations[animation] != null )
				this.currentAnimation = animation;
				
			this.resetAnimation();
			
			return old;
		}
		
		private function resetAnimation():void
		{
			this.timer = 0;
			this.animationFrame = 0;
			if ( this.currentAnimation != null && this.animations[this.currentAnimation] != null)
				this.frame = this.animations[this.currentAnimation][this.animationFrame];
			else
				this.frame = 0;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			this.timer += elapsedTime * this.fps;
			if ( this.timer > 1 )
			{
				this.timer -= 1;
				if ( this.currentAnimation == null )
				{
					this.frame += 1;
					this.frame %= this.frameCount;
				}
				else 
				{
					this.animationFrame += 1;
					this.animationFrame %= this.animations[this.currentAnimation].length;
					this.frame = this.animations[this.currentAnimation][this.animationFrame];
				}
			}
			
			if ( this.popTimer > 0 && stack.length>0)
			{
				this.popTimer -= elapsedTime;
				if ( this.popTimer <= 0 && this.stack.length>0)
				{
					var data:Object = this.stack.pop();
					this.currentAnimation = data.animation;
					this.fps = data.fps;
					this.timer = data.timer;
					this.popTimer = data.popTimer;
					this.animationFrame = data.animationFrame;
					this.frame = this.animations[this.currentAnimation][this.animationFrame];
				}
			}
			
			super.update(elapsedTime);
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch( message )
			{
				case "flip":
					if( data.horizontalFlip != undefined )
						this.horizontalFlip = data.horizontalFlip;
					if( data.verticalFlip != undefined )
						this.verticalFlip = data.verticalFlip;
					return Phantom.MESSAGE_HANDLED;
				case "playAnimation":
					var fps:int = data.fps == undefined ? -1 : data.fps;
					this.playAnimation(data.animation, fps);
					return Phantom.MESSAGE_CONSUMED;
				case "pushAnimation":
					var count:int = data.count == undefined ? 1 : data.count;
					fps = data.fps == undefined ? -1 : data.fps;
					this.pushAnimation(data.animation, count, fps);
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
		override public function getProperty(property:String, componentClass:Class = null):Object 
		{
			switch (property) {
				case "currentAnimation": {
					return ( { animation:this.currentAnimation, fps: this.fps, frame:this.frame, animationFrame:this.animationFrame } );
				}
			}
			return super.getProperty(property, componentClass);
		}
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			var dx:Number = x - (this.width / 2);
			var dy:Number = y - (this.height / 2);
			
			var fx:Number = this.width * (this.frame % this.framesX);
			var fy:Number = this.height * Math.floor(this.frame / this.framesX);
			
			
			this.mat.identity();
			this.mat.translate( -fx - this.width * 0.5, -fy - this.height * 0.5);
			
			
			
			if ( horizontalFlip )
				angle += Math.PI;
			if ( verticalFlip )
				angle += Math.PI;
			angle %= Math.PI*2;
			
			this.mat.rotate(angle);
			this.mat.scale( (horizontalFlip ? -1 : 1)* zoom, (verticalFlip ? -1 : 1) * zoom);
			
			this.mat.translate( dx + this.width * 0.5, dy + this.height * 0.5 );
			
			graphics.beginBitmapFill(this.data, this.mat, true, true);
			graphics.drawRect(dx, dy, this.width, this.height);
			graphics.endFill();
			
		}
		
		
	
	}

}