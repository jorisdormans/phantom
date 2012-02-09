package nl.jorisdormans.phantom2D.prefabs.platformer 
{
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PlatformerPrefab
	{
		
		public function PlatformerPrefab() 
		{
			
		}
		
		public static function generateBodyPolygon(shoulderWidth:Number, feetWidth:Number, height:Number):Vector.<Vector3D> {
			shoulderWidth *= 0.5;
			feetWidth *= 0.5;
			height *= 0.25;
			var poly:Vector.<Vector3D> = new Vector.<Vector3D>();
			poly.push(new Vector3D( -shoulderWidth, -height*3), new Vector3D(shoulderWidth, -height*3), new Vector3D( feetWidth, height), new Vector3D( -feetWidth, height));
			return poly;
		}
		
	}

}