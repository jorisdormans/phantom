package nl.jorisdormans.phantom2D.prefabs.items 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.Mover;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class ThrownMover extends Mover
	{
		private var time:Number;
		public var source:GameObject;
		public var rotation:Number;
		
		public function ThrownMover(source:GameObject, velocity:Vector3D, time:Number, friction:Number = 2, bounceRestitution:Number = 1) 
		{
			this.time = time;
			this.source = source;
			rotation = 24;
			super(velocity, friction, bounceRestitution);
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			if (other == source) return false;
			if (other is Item && (other as Item).equipedBy == source) return false;
			//if (!other.doResponse) return false;
			return super.canCollideWith(other);
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			super.afterCollisionWith(other);
			if (other.doResponse) time *= 0.3;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			gameObject.shape.rotateBy(rotation * elapsedTime);
			time -= Math.min(time, elapsedTime);
			if (time == 0) {
				//gameObject.removeComponent(this);
				this.destroyed = true;
			}
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			gameObject.doResponse = true;
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			gameObject.doResponse = false;
		}
		
	}

}