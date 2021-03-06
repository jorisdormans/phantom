package nl.jorisdormans.phantom2D.graphics 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomSpriteRenderer extends Component implements IRenderable
	{
		private var sprite:PhantomSprite;
		public var scale:Number;
		public var frame:int;
		public var angle:Number;
		public var offset:Vector3D;
		
		
		public function PhantomSpriteRenderer(sprite:PhantomSprite, frame:int = 0, scale:Number = 1) 
		{
			this.scale = scale;
			this.frame = frame;
			this.sprite = sprite;
			angle = 0;
			offset = new Vector3D();
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			angle += this.angle;
			x += offset.x;
			y += offset.y;
			
			zoom *= scale;
			
			if (angle == 0 && zoom == 1) {
				sprite.renderFast(graphics, x, y, frame);
			} else {
				sprite.renderFrame(graphics, x, y, frame, angle, zoom);
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "setFrame":
					frame = data.frame;
					return Phantom.MESSAGE_CONSUMED;
			}
			return super.handleMessage(message, data);
		}
		
		
	}

}