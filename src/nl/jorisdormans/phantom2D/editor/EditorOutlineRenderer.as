package nl.jorisdormans.phantom2D.editor 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class EditorOutlineRenderer extends Component implements IRenderable
	{
		public var strokeWidth:Number;
		public var strokeColor:uint;
		
		public function EditorOutlineRenderer(strokeColor:uint = 0xffffff, strokeWidth:Number = 3) 
		{
			this.strokeWidth = strokeWidth;
			this.strokeColor = strokeColor;			
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.editor.IEditorRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (gameObject.layer.gameScreen.editing) {
				graphics.lineStyle(strokeWidth, strokeColor);
				gameObject.shape.drawShape(graphics, x, y, angle, zoom);
				graphics.lineStyle();
			}
		}
		
	}

}