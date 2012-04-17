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
	public class PhantomSprite
	{
		private var _width:uint;
		private var _height:uint;
		private var mat:Matrix;
		private var frames:Vector.<BitmapData>;
		
		private var imageWidth:Number;
		private var imageHeight:Number;
		private var framesX:int;
		private var framesY:int;
		
		public function PhantomSprite( img:Class, width:int, height:int )
		{
			var inst:Bitmap = new img();
			
			//this.data = inst.bitmapData;
			
			this._width = width;
			this._height = height;
			
			this.framesX = (inst.width / this.width);
			this.framesY = (inst.height / this.height);
			
			this.mat = new Matrix();
			this.mat.identity();
			
			//this.frameCount = this.framesX * this.framesY;
			//this.frame = 0;
			
			frames = new Vector.<BitmapData>();
			for (var y:int = 0; y < framesY; y++) {
				for (var x:int = 0; x < framesX; x++) {
					var fx:Number = this.width * x;
					var fy:Number = this.height * y;
					
					this.mat.identity();
					this.mat.translate( -fx, -fy);
					
					var bmpData:BitmapData = new BitmapData(this.width, this.height, true, 0x00888888);
					bmpData.draw(inst, mat);
					frames.push(bmpData);
				}
			}
			
			inst = null;
		}
		
		public function renderFrame(graphics:Graphics, x:Number, y:Number, frame:int, angle:Number = 0, zoom:Number = 1):void 
		{
			if (frame<0 || frame >= frames.length) return;
			var dx:Number = x - (this.width / 2) * zoom;
			var dy:Number = y - (this.height / 2) * zoom;
			
			this.mat.identity();
			this.mat.translate( - this.width * 0.5, - this.height * 0.5);

			/*if ( horizontalFlip )
				angle += Math.PI;
			if ( verticalFlip )
				angle += Math.PI;
			angle %= Math.PI*2;*/
			
			this.mat.rotate(angle);
			//this.mat.scale( (horizontalFlip ? -1 : 1)* zoom, (verticalFlip ? -1 : 1) * zoom);
			this.mat.scale( zoom, zoom);
			
			this.mat.translate( dx + this.width * 0.5*zoom, dy + this.height * 0.5*zoom );
			
			graphics.beginBitmapFill(this.frames[frame], this.mat, false, true);
			graphics.drawRect(dx, dy, this.width*zoom, this.height*zoom);
			graphics.endFill();
			
		}	
		
		public function renderFast(graphics:Graphics, x:Number, y:Number, frame:int):void {
			if (frame<0 || frame >= frames.length) return;
			var dx:Number = x - (this.width / 2);
			var dy:Number = y - (this.height / 2);
			
			this.mat.identity();
			this.mat.translate( - this.width * 0.5, - this.height * 0.5);
			this.mat.translate( dx + this.width * 0.5, dy + this.height * 0.5 );
			
			graphics.beginBitmapFill(this.frames[frame], this.mat, false, true);
			graphics.drawRect(dx, dy, this.width, this.height);
			graphics.endFill();
			
			
		}
		
		public function get width():uint 
		{
			return _width;
		}
		
		public function get height():uint 
		{
			return _height;
		}
		
		public function get frameCount():uint {
			return frames.length;
		}
		
		
		
		
	
	}

}