package nl.jorisdormans.phantom2D.prefabs.items 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.Mover;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ArrowMover extends Mover
	{
		private var time:Number;
		public var source:GameObject;
		public var survivalChance:Number;
		
		public function ArrowMover(source:GameObject, velocity:Vector3D, time:Number, survivalChance:Number = 0, friction:Number = 0, bounceRestitution:Number = 0) 
		{
			this.time = time;
			this.source = source;
			super(velocity, friction, bounceRestitution);
			this.survivalChance = survivalChance;
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			if (other == source) return false;
			if (other is Item && (other as Item).equipedBy == source) return false;
			//if (!other.doResponse) return false;
			//return super.canCollideWith(other);
			return true;
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			if (other.doResponse) this.destroyed = true;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			time -= Math.min(time, elapsedTime);
			if (time == 0) {
				this.destroyed = true;
			}
		}
		
		override public function onRemove():void 
		{
			if (Math.random() >= survivalChance) {
				gameObject.destroyed = true;
			}
		}
		
	}

}