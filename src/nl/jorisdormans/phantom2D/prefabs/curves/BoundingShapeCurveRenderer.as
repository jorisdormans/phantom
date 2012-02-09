package nl.jorisdormans.phantom2D.prefabs.curves 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingPolygon;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.PseudoRandom;
	/**
	 * A Component that simply renders the GameObject´s bounding shape with the specified colors and strokewidth
	 * @author Joris Dormans
	 */
	public class BoundingShapeCurveRenderer extends Component implements IRenderable
	{
		public var strokeWidth:Number;
		public var strokeColorLight:uint;
		public var strokeColorTween:uint;
		public var strokeColorDark:uint;
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
		private var commandsFill:Vector.<int>;
		private var dataFill:Vector.<Number>;
		private var calculatedFill:Vector.<Number>;
		private var controlX:Number;
		private var controlY:Number;
		private var previous:BoundingShapeCurveRenderer;
		private var length:Number;
		private var threshold:Number = 0.65;
		public var verticalReverse:Boolean = false;
		
		public function BoundingShapeCurveRenderer(fillColor:uint, strokeColorLight:uint, strokeColorTween:uint, strokeColorDark:uint, strokeWidth:Number, previous:BoundingShapeCurveRenderer) 
		{
			this.strokeWidth = strokeWidth;
			this.strokeColorLight = strokeColorLight;
			this.strokeColorTween = strokeColorTween;
			this.strokeColorDark = strokeColorDark;
			this.fillColor = fillColor;
			this.alpha = 1;
			this.previous = previous;
			
			commands = new Vector.<int>();
			data = new Vector.<Number>();
			calculated = new Vector.<Number>();
			commandsFill = new Vector.<int>();
			dataFill = new Vector.<Number>();
			calculatedFill = new Vector.<Number>();
		}
		
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			
			for (var i:int = 0; i < gameObject.shape.points.length; i++) {
				if (i == 0) {
					commandsFill.push(GraphicsPathCommand.MOVE_TO);
				} else {
					commandsFill.push(GraphicsPathCommand.LINE_TO);
				}
				dataFill.push(gameObject.shape.points[i].x, gameObject.shape.points[i].y);
				calculatedFill.push(0, 0);
			}
			
			
			startX = gameObject.shape.points[0].x;
			startY = gameObject.shape.points[0].y;
			endX = gameObject.shape.points[1].x;
			endY = gameObject.shape.points[1].y;
			
			unitX = endX - startX;
			unitY = endY - startY;
			var d:Number = Math.sqrt(unitX * unitX + unitY * unitY);
			length = d;
			if (d > 0) {
				unitX /= d;
				unitY /= d;
			}
			
			if (!verticalReverse && unitX >= threshold || verticalReverse && unitX <= -threshold) {
				gameObject.sortOrder++;
			}
			
			
			if (previous != null) {
				calculateControlPoint();
			} else {
				createDefaultControlPoint();
			}
			
			if (!(gameObject.shape is BoundingPolygon)) return;
			
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.CURVE_TO, GraphicsPathCommand.CURVE_TO, GraphicsPathCommand.CURVE_TO, GraphicsPathCommand.CURVE_TO);
			
			var ux:Number = unitX * strokeWidth * 0.5;
			var uy:Number = unitY * strokeWidth * 0.5;
			
			var usx:Number = controlX - startX;
			var usy:Number = controlY - startY;
			d = Math.sqrt(usx * usx + usy * usy);
			if (d > 0) {
				usx /= d;
				usy /= d;
			}
			usx *= strokeWidth * 0.5;
			usy *= strokeWidth * 0.5;

			var uex:Number = endX - controlX;
			var uey:Number = endY - controlY;
			d = Math.sqrt(uex * uex + uey * uey);
			if (d > 0) {
				uex /= d;
				uey /= d;
			}
			uex *= strokeWidth * 0.5;
			uey *= strokeWidth * 0.5;

			
			data.push(startX - usy, startY + usx);
			data.push(startX - usx, startY - usy, startX + usy, startY - usx);
			//data.push(startX + usy, startY - usx);
			
			data.push(controlX + uy, controlY - ux, endX + uey, endY - uex);
			data.push(endX + uex, endY + uey, endX - uey, endY + uex);
			//data.push(endX - uey, endY + uex);
			
			data.push(controlX - uy, controlY + ux, startX - usy, startY + usx);
			
			for (i = 0; i < data.length; i++) calculated.push(data[i]);
		}
		
		public function isHorizontal():Boolean {
			return (!verticalReverse && unitX >= threshold || verticalReverse && unitX <= -threshold);
		}
		
		private function calculateControlPoint():void 
		{
			var ux:Number = previous.endX-previous.controlX;
			var uy:Number = previous.endY - previous.controlY;
			var d:Number = Math.sqrt(ux * ux + uy * uy);
			if (d > 0) {
				ux /= d;
				uy /= d;
			}
			//dot
			d = ux * unitX + uy * unitY;
			if (d < 0.7) {
				//d = strokeWidth * 2;
				createDefaultControlPoint();
			} else {
				d = 2 * strokeWidth / d;
				if (d > length) d = length * 0.5;
				controlX = startX + ux * d;
				controlY = startY + uy * d;
				dataFill.splice(2, 0, controlX, controlY);
				calculatedFill.push(0, 0);
				commandsFill[1] = GraphicsPathCommand.CURVE_TO;
			}
			
		}
		
		private function createRandomControlPoint():void 
		{
			var d:Number = PseudoRandom.nextFloat() * 0.5 + 0.25;
			controlX = startX + (endX - startX) * d;
			controlY = startY + (endY - startY) * d;
			
			d = (PseudoRandom.nextFloat() - PseudoRandom.nextFloat()) * strokeWidth * 0.5;
			controlX += unitY * d;
			controlY -= unitX * d;
			
			dataFill.splice(2, 0, controlX, controlY);
			calculatedFill.push(0, 0);
			commandsFill[1] = GraphicsPathCommand.CURVE_TO;
		}
		
		private function createDefaultControlPoint():void 
		{
			controlX = (endX + startX) * 0.5;
			controlY = (endY + startY) * 0.5;
		}
		
		public function addSpike(length:Number, width:Number):void {
			var pos:Vector3D = new Vector3D();
			var dir:Vector3D = new Vector3D();
			var l:Number = Math.abs(width / this.length);
			var p:Number = PseudoRandom.nextFloat()*(1-2*l)+l; 
			MathUtil.getBezierPosition(pos, startX, startY, controlX, controlY, endX, endY, p);
			MathUtil.getBezierNormal(dir, startX, startY, controlX, controlY, endX, endY, p);
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
			data.push(pos.x + dir.x * length, pos.y + dir.y * length);
			data.push(pos.x - dir.y * width, pos.y + dir.x * width);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
		}
		
		public function addVerticalSpike(length:Number, width:Number):void {
			var pos:Vector3D = new Vector3D();
			var dir:Vector3D = new Vector3D();
			var l:Number = Math.abs(width / this.length);
			var p:Number = PseudoRandom.nextFloat()*(1-2*l)+l; 
			MathUtil.getBezierPosition(pos, startX, startY, controlX, controlY, endX, endY, p);
			MathUtil.getBezierNormal(dir, startX, startY, controlX, controlY, endX, endY, p);
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO, GraphicsPathCommand.LINE_TO);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
			//data.push(pos.x + dir.x * length, pos.y + dir.y * length);
			data.push(pos.x + 0, pos.y - 1 * length);
			data.push(pos.x - dir.y * width, pos.y + dir.x * width);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
		}
		
		public function addBulge(length:Number, width:Number):void {
			var pos:Vector3D = new Vector3D();
			var dir:Vector3D = new Vector3D();
			var l:Number = Math.abs(width / this.length);
			var p:Number = PseudoRandom.nextFloat()*(1-2*l)+l; 
			MathUtil.getBezierPosition(pos, startX, startY, controlX, controlY, endX, endY, p);
			MathUtil.getBezierNormal(dir, startX, startY, controlX, controlY, endX, endY, p);
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.CURVE_TO, GraphicsPathCommand.LINE_TO);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
			data.push(pos.x + dir.x * length, pos.y + dir.y * length);
			//data.push(pos.x + 0, pos.y - 1 * length);
			data.push(pos.x - dir.y * width, pos.y + dir.x * width);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
		}
		
		public function addVertcialBulge(length:Number, width:Number):void {
			var pos:Vector3D = new Vector3D();
			var dir:Vector3D = new Vector3D();
			var l:Number = Math.abs(width / this.length);
			var p:Number = PseudoRandom.nextFloat()*(1-2*l)+l; 
			MathUtil.getBezierPosition(pos, startX, startY, controlX, controlY, endX, endY, p);
			MathUtil.getBezierNormal(dir, startX, startY, controlX, controlY, endX, endY, p);
			commands.push(GraphicsPathCommand.MOVE_TO, GraphicsPathCommand.CURVE_TO, GraphicsPathCommand.LINE_TO);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
			//data.push(pos.x + dir.x * length, pos.y + dir.y * length);
			data.push(pos.x + 0, pos.y - 1 * length);
			data.push(pos.x - dir.y * width, pos.y + dir.x * width);
			data.push(pos.x + dir.y * width, pos.y - dir.x * width);
		}
		
		
		/* INTERFACE phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			for (var i:int = 0; i < dataFill.length; i += 2) {
				calculatedFill[i] = dataFill[i] + x;
				calculatedFill[i + 1] = dataFill[i + 1] + y;
			}

			
			graphics.lineStyle(0, fillColor);
			graphics.beginFill(fillColor, alpha);
			graphics.drawPath(commandsFill, calculatedFill);
			graphics.endFill();
			graphics.lineStyle();
			
			var c:uint;
			
			if (!verticalReverse && unitX >= threshold || verticalReverse && unitX <= -threshold) {
				var ux:Number = unitX * strokeWidth * 0.75;
				var uy:Number = unitY * strokeWidth * 0.75;
				if (verticalReverse) {
					ux *= -1;
					uy *= -1;
				}
				
				for (i = 0; i < data.length; i += 2) {
					calculated[i] = data[i] + x - uy;
					calculated[i + 1] = data[i + 1] + y + ux;
				}
			
				graphics.beginFill(strokeColorTween);
				graphics.drawPath(commands, calculated, GraphicsPathWinding.NON_ZERO);
				graphics.endFill();
				c = strokeColorLight;
			} else {
				c = strokeColorDark;
			}
			
			for (i = 0; i < data.length; i += 2) {
				calculated[i] = data[i] + x;
				calculated[i + 1] = data[i + 1] + y;
			}
			
			graphics.beginFill(c);
			graphics.drawPath(commands, calculated, GraphicsPathWinding.NON_ZERO);
			graphics.endFill();
			
		}
		
		public function shift(dx:Number, dy:Number):void 
		{
			for (var i:int = 0; i < dataFill.length; i += 2) {
				dataFill[i] += dx;;
				dataFill[i + 1] += dy;
			}
			for (i = 0; i < data.length; i += 2) {
				data[i] += dx;;
				data[i + 1] += dy;
			}
		}
		
	}

}