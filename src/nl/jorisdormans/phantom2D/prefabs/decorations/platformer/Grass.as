package nl.jorisdormans.phantom2D.prefabs.decorations.platformer 
{
	import flash.display.GraphicsPathCommand;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.graphics.PhantomShape;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	import nl.jorisdormans.phantom2D.objects.shapes.BoundingBoxOA;
	import nl.jorisdormans.phantom2D.prefabs.decorations.Decoration;
	import nl.jorisdormans.phantom2D.prefabs.PhantomShapeRenderer;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.PseudoRandom;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Grass extends Decoration
	{
		private var outline:PhantomShape;
		private var commands:Array;
		private var data:Array;
		private var renderer:PhantomShapeRenderer;
		
		public function Grass() 
		{
			renderer = new PhantomShapeRenderer(0x000000, outline);
		}
		
		override public function initialize(objectLayer:ObjectLayer, position:Vector3D, data:Object = null):void 
		{
			addShape(new BoundingBoxOA(position, new Vector3D(20, 10)));
			super.initialize(objectLayer, position, data);
			addComponent(renderer);
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			return false;
			//return super.canCollideWith(other);
		}
		
		override public function generate():void 
		{
			//super.generate();
			PseudoRandom.seed = this.randomSeed;
			if (!commands) commands = new Array();
			if (!data) data = new Array();
			
			var c:int = 0;
			var d:int = 0;
			var a:Number = -20 + PseudoRandom.nextFloat() * 10;
			
			var w:Number = 25+PseudoRandom.nextFloat()*10;
			var h:Number = 7+PseudoRandom.nextFloat()*5;
			
			commands[c++] = GraphicsPathCommand.MOVE_TO;
			commands[c++] = GraphicsPathCommand.LINE_TO;

			data[d++] = -w*0.5;
			data[d++] = h;
			data[d++] = w*0.5;
			data[d++] = h;
			
			commands[c++] = GraphicsPathCommand.LINE_TO;
			data[d++] = w * Math.cos(a*MathUtil.TO_RADIANS) * 0.5;
			data[d++] = h * Math.sin(a * MathUtil.TO_RADIANS) + h;
			
			a -= 6+PseudoRandom.nextFloat()*6;
			
			while (a > -170) {
				commands[c++] = GraphicsPathCommand.LINE_TO;
				var l:Number = PseudoRandom.nextFloat() * 0.3 + 0.7;
				data[d++] = w * Math.cos(a*MathUtil.TO_RADIANS) * l;
				data[d++] = 2*h * Math.sin(a*MathUtil.TO_RADIANS) * l + h;
				a -= 6+PseudoRandom.nextFloat()*6;
				commands[c++] = GraphicsPathCommand.LINE_TO;
				data[d++] = w * Math.cos(a*MathUtil.TO_RADIANS) * 0.5;
				data[d++] = h * Math.sin(a*MathUtil.TO_RADIANS) + h;
				a -= 6 + PseudoRandom.nextFloat() * 6;
			}
			
			commands[c++] = GraphicsPathCommand.LINE_TO;

			data[d++] = -w*0.5;
			data[d++] = h;
			data.splice(d, data.length - d);
			commands.splice(c, commands.length - c);
			
			
			if (!outline) {
				outline = new PhantomShape(commands, data);
			} else {
				trace("CHANGING", d, data.length);
				outline.changeData(commands, data);
			}
			
			if (renderer) renderer.color = 0x008800;
			
		}
	}

}