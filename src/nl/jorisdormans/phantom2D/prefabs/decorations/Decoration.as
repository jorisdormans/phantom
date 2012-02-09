package nl.jorisdormans.phantom2D.prefabs.decorations 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingBoxOA;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Decoration extends GameObject
	{
		private var randomSeed:int;
		private var drawWidth:Number;
		private var drawHeight:Number;
		private var objectWidth:Number;
		private var objectHeight:Number;
		
		public function Decoration() 
		{
			randomSeed = Math.random() * int.MAX_VALUE;
			generate();
		}
		
		public function generate():void {
			drawWidth = 0;
			drawHeight = 0;
		}
		
		protected function setObjectSize(width:Number, height:Number):void {
			if (!(shape is BoundingBoxOA)) {
				var position:Vector3D = new Vector3D();
				if (shape) {
					position.x = shape.position.x;
					position.y = shape.position.y;
					position.z = shape.position.z;
				}
				addShape(new BoundingBoxOA(position, new Vector3D(width * 0.5, height * 0.5)));
			} else {
				(shape as BoundingBoxOA).halfSize.x = width * 0.5;
				(shape as BoundingBoxOA).halfSize.y = height * 0.5;
				(shape as BoundingBoxOA).createProjections();
				(shape as BoundingBoxOA).setExtremes();
			}
		}
		
		
		override public function generateXML():XML 
		{
			var xml:XML = super.generateXML(); 
			xml.@randomSeed = randomSeed;
			generate();
		}
		
		override public function readXML(xml:XML):void 
		{
			randomSeed = xml.@randomSeed;
			super.readXML(xml);
		}
		
	}

}