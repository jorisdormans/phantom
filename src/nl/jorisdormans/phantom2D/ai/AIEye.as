package nl.jorisdormans.phantom2D.ai 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.lightEffects.LightEffectLayer;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class AIEye extends Component //implements IRenderable
	{
		
		private var targetClass:Class;
		private var visionDistance:Number;
		private var senseDistance:Number;
		private var visionAngle:Number;
		public var targetLocation:Vector3D;	
		public var targetObject:GameObject;
		
		private static var d:Vector3D = new Vector3D();
		
		private var lightLayer:LightEffectLayer;
		
		public function AIEye(visionDistance:Number, senseDistance:Number, visionAngle:Number, targetClass:Class) 
		{
			this.visionAngle = visionAngle * MathUtil.TO_RADIANS *0.5;
			this.visionDistance = visionDistance;
			this.senseDistance = senseDistance;
			this.targetClass = targetClass;			
			this.targetLocation = new Vector3D( -1, -1, -1);
			this.targetObject = null;
		}
		
		public function spotTarget():Boolean {
			lightLayer = gameObject.layer.gameScreen.getComponentByClass(LightEffectLayer, 0) as LightEffectLayer;
			//trace("lightLayer", lightLayer);

			var l:int = gameObject.layer.objects.length;
			var o:GameObject = null;
			var ds:Number = visionDistance * visionDistance;
			for (var i:int = 0; i < l; i++) {
				if (gameObject.layer.objects[i] is targetClass) {
					
					d.x = gameObject.layer.objects[i].position.x - gameObject.position.x;
					d.y = gameObject.layer.objects[i].position.y - gameObject.position.y;
					d.z = gameObject.layer.objects[i].position.z - gameObject.position.z;
					var dds:Number = d.lengthSquared;
					
					var ll:Number;
					if (lightLayer) {
						ll = lightLayer.lightAt(gameObject.layer.objects[i].position.x, gameObject.layer.objects[i].position.y);
					} else {
						ll = 1;
					}
					if (ll < 0.3 && dds>senseDistance*senseDistance*3) {
						continue;
					}
					var a:Number;
					if (dds < senseDistance * senseDistance) {
						a = 0;
					} else {
						a = MathUtil.angleDifference(Math.atan2(d.y, d.x), gameObject.shape.orientation);
					}
					if (Math.abs(a)<=visionAngle) {
						if (dds < ds && gameObject.layer.rayTraceToObject(gameObject, gameObject.layer.objects[i])) {
							
							ds = dds;
							o = gameObject.layer.objects[i];
						}
					}
				}
			}
			
			if (o != null) {
				targetObject = o;
				targetLocation.x = targetObject.position.x;
				targetLocation.y = targetObject.position.y;
				targetLocation.z = targetObject.position.z;
				return true;
			} else {
				targetObject = null;
				return false;
			}
			
		}
		
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (targetObject) {
				graphics.lineStyle(2, 0xff0000);
			} else {
				graphics.lineStyle(2, 0xffffff);
			}
			graphics.drawCircle(x, y, senseDistance * zoom);
			
			var a:Number = angle + visionAngle;
			graphics.moveTo(x, y);
			graphics.lineTo(x + Math.cos(a) * zoom * visionDistance, y + Math.sin(a) * zoom * visionDistance);
			var step:Number = 5 * MathUtil.TO_RADIANS;
			var b:Number = step;
			while (b < visionAngle * 2 - step) {
				graphics.lineTo(x + Math.cos(a-b) * zoom * visionDistance, y + Math.sin(a-b) * zoom * visionDistance);
				b += step;
			}
			a = angle - visionAngle;
			graphics.lineTo(x + Math.cos(a) * zoom * visionDistance, y + Math.sin(a) * zoom * visionDistance);
			graphics.lineTo(x, y);
			graphics.lineStyle();
		}
	}

}