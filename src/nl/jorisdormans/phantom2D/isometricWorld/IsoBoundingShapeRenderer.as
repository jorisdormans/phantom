package nl.jorisdormans.phantom2D.isometricWorld 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingCircle;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class IsoBoundingShapeRenderer extends Component implements IIsoRenerable
	{
		public var strokeWidth:Number;
		public var strokeColor:uint;
		public var fillColor:uint;
		
		public function IsoBoundingShapeRenderer(fillColor:uint = 0xffffff, strokeColor:uint = 0xffffff, strokeWidth:Number = -1) 
		{
			this.strokeWidth = strokeWidth;
			this.strokeColor = strokeColor;
			this.fillColor = fillColor;
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.isometricWorld.IIsoRenerable */
		
		public function renderIso(graphics:Graphics, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void 
		{
			if (gameObject.shape is BoundingCircle) {
				drawBoundingCirlce(graphics, gameObject.shape as BoundingCircle, x, y, angle, isoX, isoY, isoZ);
				return;
			}
			graphics.beginFill(fillColor);
			if (strokeWidth>=0) {
				graphics.lineStyle(strokeWidth, strokeColor);
				gameObject.shape.drawIsoShape(graphics, x, y, angle, isoX, isoY, isoZ);
				graphics.lineStyle();
			} else {
				gameObject.shape.drawIsoShape(graphics, x, y, angle, isoX, isoY, isoZ);
			}
			graphics.endFill();
		}
		
		private function drawBoundingCirlce(graphics:Graphics, shape:BoundingCircle, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void 
		{
			var rx:Number = shape.radius * isoX;
			var ry:Number = shape.radius * isoY;
			var h:Number = shape.isoHeight * isoZ;
			graphics.beginFill(fillColor);
			if (strokeWidth>=0) {
				graphics.lineStyle(strokeWidth, strokeColor);
				graphics.drawEllipse(x - rx, y - ry, rx * 2, ry * 2);
				graphics.lineStyle();
			} else {
				graphics.drawEllipse(x - rx, y - ry, rx * 2, ry * 2);
			}
			graphics.endFill();
			
			graphics.beginFill(fillColor);
			graphics.drawRect(x - rx, y, rx * 2, h);
			graphics.endFill();
			
			graphics.beginFill(fillColor);
			if (strokeWidth>=0) {
				graphics.lineStyle(strokeWidth, strokeColor);
				graphics.drawEllipse(x - rx, y - ry + h, rx * 2, ry * 2);
				graphics.lineStyle();
			} else {
				graphics.drawEllipse(x - rx, y - ry + h, rx * 2, ry * 2);
			}
			graphics.endFill();
			
			if (strokeWidth>=0) {
				//angle += shape.orientation;
				var commands:Vector.<int> = new Vector.<int>();
				commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO);
				var data:Vector.<Number> = new Vector.<Number>();
				data.push(x, y+h);
				data.push(x + rx * Math.cos(angle), y + h + ry * Math.sin(angle));
				data.push(x-rx, y+h);
				data.push(x-rx, y);
				data.push(x+rx, y+h);
				data.push(x + rx, y);
				graphics.lineStyle(strokeWidth, strokeColor);
				graphics.drawPath(commands, data);			
				graphics.lineStyle();
			}
			
		}
		
	}

}