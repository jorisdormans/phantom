package nl.jorisdormans.phantom2D.prefabs.triggers 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PositionMarker extends Component implements IRenderable
	{
		private var strokeWidth:Number;
		private var strokeColor:uint;
		
		public function PositionMarker(strokeColor:uint = 0xffffff, strokeWidth:Number = 1) 
		{
			this.strokeColor = strokeColor;
			this.strokeWidth = strokeWidth;
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.lineStyle(strokeWidth, strokeColor);
			graphics.moveTo(x - 5, y);
			graphics.lineTo(x + 5, y);
			graphics.moveTo(x, y - 5);
			graphics.lineTo(x, y + 5);
			graphics.lineStyle();
		}
		
	}

}