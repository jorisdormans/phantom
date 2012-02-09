package nl.jorisdormans.phantom2D.prefabs.curves 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.objects.Component;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * A Component that simply renders the GameObject´s bounding shape with the specified colors and strokewidth
	 * @author Joris Dormans
	 */
	public class BoundingShapeEdgeRenderer extends Component implements IRenderable
	{
		public var strokeWidth:Number;
		public var strokeColor:uint;
		public var strokeColor2:uint;
		public var fillColor:uint;
		public var alpha:Number;
		private var startX:Number;
		private var startY:Number;
		private var endX:Number;
		private var endY:Number;
		private var unitX:Number;
		private var unitY:Number;
		private var commands:Vector.<int>;
		private var data:Vector.<Number>;
		private var calculated:Vector.<Number>;
		
		public function BoundingShapeEdgeRenderer(fillColor:uint = 0xffffff, strokeColor:uint = 0xffffff, strokeWidth:Number = -1, alpha:Number = 1) 
		{
			this.strokeWidth = strokeWidth;
			this.strokeColor = strokeColor;
			this.fillColor = fillColor;
			this.alpha = alpha;
			
			commands = new Vector.<int>();
			data = new Vector.<Number>();
			calculated = new Vector.<Number>();
		}
		
		override public function onAdd():void 
		{
			super.onAdd();
			
			startX = gameObject.shape.points[0].x;
			startY = gameObject.shape.points[0].y;
			endX = gameObject.shape.points[1].x;
			endY = gameObject.shape.points[1].y;
			
			unitX = endX - startX;
			unitY = endY - startY;
			var d:Number = Math.sqrt(unitX * unitX + unitY * unitY);
			if (d > 0) {
				unitX /= d;
				unitY /= d;
			}
			if (unitX < 0.4) {
				strokeColor = fillColor;
			}
			d = Math.sin(70 * MathUtil.TO_RADIANS) * unitX + Math.cos(70 * MathUtil.TO_RADIANS) * unitY;
			
			if (unitX >= 0.4) {
				strokeColor2 = DrawUtil.lerpColor(strokeColor, 0x000000, 0.3);
				gameObject.sortOrder++;
			}
			
			if (d > 0) strokeColor = DrawUtil.lerpColor(strokeColor, 0xffffff, d * 0.5);
			if (d < 0) strokeColor = DrawUtil.lerpColor(strokeColor, 0x000000, d * -0.5);
			
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.CURVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.CURVE_TO);
			
			var ux:Number = unitX * strokeWidth * 0.5;
			var uy:Number = unitY * strokeWidth * 0.5;
			
			data.push(startX - uy, startY + ux);
			data.push(startX - ux*2, startY - uy*2, startX + uy, startY - ux);
			
			data.push(endX + uy, endY - ux);
			data.push(endX + ux * 2, endY + uy * 2, endX - uy, endY + ux);
			
			for (var i:int = 0; i < data.length; i++) calculated.push(data[i]);
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "changeFillColor":
					fillColor = data.color;
					return MESSAGE_HANDLED;
				case "changeStrokeColor":
					strokeColor = data.color;
					return MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			graphics.lineStyle(0, fillColor);
			graphics.beginFill(fillColor, alpha);
			gameObject.shape.drawShape(graphics, x, y, angle, zoom);
			graphics.endFill();
			graphics.lineStyle();
			
			
			if (unitX >= 0.4) {
				var ux:Number = unitX * strokeWidth * 0.5;
				var uy:Number = unitY * strokeWidth * 0.5;
				
				for (var i:int = 0; i < data.length; i += 2) {
					calculated[i] = data[i] + x - uy;
					calculated[i + 1] = data[i + 1] + y + ux;
				}
			
				graphics.beginFill(strokeColor2);
				graphics.drawPath(commands, calculated);
				graphics.endFill();
				
			}
			
			for (i = 0; i < data.length; i += 2) {
				calculated[i] = data[i] + x;
				calculated[i + 1] = data[i + 1] + y;
			}
			
			graphics.beginFill(strokeColor);
			graphics.drawPath(commands, calculated);
			graphics.endFill();
		}
		
	}

}