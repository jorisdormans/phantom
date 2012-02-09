package nl.jorisdormans.phantom2D.prefabs.curves 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.objects.TiledObjectLayer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class CurveLayer extends TiledObjectLayer
	{
		public var curves:Vector.<Curve>;
		
		/**
		 * An array that contains the game objects that can be placed in this level by the editor as tiles
		 */
		public var curveList:Array;
		
		public function CurveLayer(tileSize:int, tilesX:int, tilesY:int, physicsExecutionCount:int = 1) 
		{
			curves = new Vector.<Curve>();
			curveList = new Array();
			super(tileSize, tilesX, tilesY, physicsExecutionCount);
		}
		
		override public function clear():void 
		{
			super.clear();
			curves.splice(0, curves.length);
		}
		
		public function renderCurveData(graphics:Graphics, zoom:Number, selectedCurve:Curve, selectedCurvePoint:int, hoverCurve:Curve, hoverCurvePoint:int):void {
			for (var i:int = 0; i < curves.length; i++) {
				curves[i].renderCurveData(graphics, zoom, gameScreen.camera, selectedCurve, selectedCurvePoint, hoverCurve, hoverCurvePoint);
			}
		}
		
		public function findHoverCurvePoint(x:Number, y:Number, hoverCurve:Curve):int 
		{
			for (var i:int = curves.length - 1; i >= 0; i--) {
				for (var j:int = curves[i].points.length - 1; j >= 0; j--) {
					var dx:Number = x - curves[i].points[j].x;
					var dy:Number = y - curves[i].points[j].y;
					if (Math.abs(dx) < Curve.POINT_SIZE && Math.abs(dy) < Curve.POINT_SIZE) {
						hoverCurve = curves[i];
						trace(hoverCurve);
						return j;
					}
				}
			}
			hoverCurve = null;
			return -1;
			
		}
		
		public function removeCurvePoint(selectedCurve:Curve, selectedCurvePoint:int):void 
		{
			if (selectedCurvePoint >= 0 && selectedCurvePoint < selectedCurve.points.length) {
				selectedCurve.points.splice(selectedCurvePoint, 1);
			}
			if (selectedCurve.points.length == 0) {
				for (var i:int = 0; i < curves.length; i++) {
					if (curves[i] == selectedCurve) {
						curves.splice(i, 1);
						break;
					}
				}
			}
		}
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML();
			for (var i:int = 0; i < curves.length; i++) {
				xml.appendChild(curves[i].generateXML(this));
			}
			return xml;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			for (var i:int = 0; i < xml.curve.length(); i++) {
				var curve:Curve = new Curve();
				curve.readXML(xml.curve[i], this);
				curve.build(this, curve.tileClass);
				curves.push(curve);
			}
			sortObjects();
		}
		
		
	}

}