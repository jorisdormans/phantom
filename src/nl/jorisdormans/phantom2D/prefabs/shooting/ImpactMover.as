package nl.jorisdormans.phantom2D.prefabs.shooting 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.Mover;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ImpactMover extends Mover
	{
		private var source:GameObject;
		private var damage:Number;
		
		public function ImpactMover(source:GameObject, damage:Number, velocity:Vector3D, friction:Number = 2, bounceRestitution:Number = 1) 
		{
			this.source = source;
			this.damage = damage;
			super(velocity, friction, bounceRestitution);
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			if (source == other) return false;
			return super.canCollideWith(other);
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			other.sendMessage("damage", { damage:damage, source: this, shooter: source } );
			gameObject.destroyed = true;
			super.afterCollisionWith(other);
		}
		
	}

}