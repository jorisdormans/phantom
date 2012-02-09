package nl.jorisdormans.phantom2D.prefabs.particles 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Camera;
	import nl.jorisdormans.phantom2D.particles.Particle;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class FlameParticle extends Particle
	{
		public function FlameParticle() 
		{
			
		}
		
		override public function initialize(life:Number, position:Vector3D, velocity:Vector3D):void 
		{
			super.initialize(life, position, velocity);
			color = 0xffff00;
		}
		
		override public function render(graphics:Graphics, camera:Camera):void 
		{
			color = DrawUtil.lerpColor(color, 0xbb0000, Math.min(living*3, 1));
			graphics.beginFill(color);
			graphics.drawCircle(position.x - camera.left, position.y - camera.top, Math.min(living*90, Math.min(5, life * 15)));
			graphics.endFill();		
		}
		
		
	}

}