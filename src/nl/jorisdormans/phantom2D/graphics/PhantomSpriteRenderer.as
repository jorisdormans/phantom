package nl.jorisdormans.phantom2D.graphics 
{
	import flash.display.Graphics;
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
		public var frame:int;
		
		public function PhantomSpriteRenderer(sprite:PhantomSprite, frame:int = 0) 
		{
			this.frame = frame;
			this.sprite = sprite;
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
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