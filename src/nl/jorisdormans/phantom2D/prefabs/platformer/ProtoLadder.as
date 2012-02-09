package nl.jorisdormans.phantom2D.prefabs.platformer 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ProtoLadder extends ProtoPlatform
	{
		
		public function ProtoLadder() 
		{
			super(3, 0);
			sortOrder = -10;
			doResponse = false;
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			return false;
			//return super.canCollideWith(other);
		}
		
		
	}

}