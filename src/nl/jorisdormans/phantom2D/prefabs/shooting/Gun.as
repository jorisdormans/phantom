package nl.jorisdormans.phantom2D.prefabs.shooting 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Gun extends Component
	{
		private var position:Vector3D;
		private var direction:Vector3D;
		private var bullet:Class;
		private var message:String;
		private var ammo:String;
		private var drain:Number;
		
		public function Gun(message:String, bullet:Class, position:Vector3D, direction:Vector3D, ammo:String = null, drain:Number = 1) 
		{
			this.message = message;
			this.bullet = bullet;
			this.position = position;
			this.direction = direction;
			this.ammo = ammo;
			this.drain = drain;
		}
		
		private function shoot():void {
			if (ammo) {
				if (gameObject.sendMessage("try drain " + ammo, {amount: drain}) == Phantom.MESSAGE_NOT_HANDLED) {
					return;
				}
			}
			var p:Vector3D = gameObject.shape.position.clone();
			var v:Vector3D = new Vector3D();
			var cos:Number = Math.cos(gameObject.shape.orientation);
			var sin:Number = Math.sin(gameObject.shape.orientation);
			
			p.x += cos * position.x - sin * position.y;
			p.y += sin * position.x + cos * position.y;
			p.z += position.z;
			
			v.x = cos * direction.x - sin * direction.y;
			v.y = sin * direction.x + cos * direction.y;
			v.z = direction.z;
			
			var b:GameObject = new bullet() as GameObject;
			if (b) {
				b.initialize(gameObject.layer, p, { direction:v, source:gameObject } );
			}
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case this.message:
					shoot();
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
	}

}