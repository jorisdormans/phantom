package nl.jorisdormans.phantom2D.prefabs.platformer 
{
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ProtoSlidingSlope extends ProtoPlatform
	{
		
		public function ProtoSlidingSlope() 
		{
			super();
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