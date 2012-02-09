package nl.jorisdormans.phantom2D.prefabs.items 
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author ...
	 */
	public class SimpleDoorRenderer extends Component implements IRenderable
	{
		private var lock:Lock;
		private var color:uint;
		private var distance:Number;
		
		public function SimpleDoorRenderer(color:uint, distance:Number) 
		{
			this.color = color;
			this.distance = distance;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			lock = gameObject.getComponentByClass(Lock) as Lock;
			if (!lock) {
				trace("PHANTOM: Warning: SimpleDoorRenderer added to GameObject that has no Lock.");
			}
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@color = StringUtil.toColorString(color);
			xml.@distance = distance;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@color.length() > 0) color = StringUtil.toColor(xml.@color);
			if (xml.@distance.length() > 0) distance = xml.@distance;
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void 
		{
			if (lock) {
				if (lock.closed) {
					graphics.beginFill(color);
					gameObject.shape.drawShape(graphics, x, y, angle, zoom);
					graphics.endFill();
					var startPosition:Number = (lock.keyCount - 1) * distance * 0.5;
					var cos:Number = Math.cos(angle + gameObject.shape.orientation) * zoom;
					var sin:Number = Math.sin(angle + gameObject.shape.orientation) * zoom;
					var dx:Number = x - startPosition * cos;
					var dy:Number = y - startPosition * sin
					for (var i:int = 0; i < lock.keyCount; i++) {
						graphics.beginFill(0x000000);
						graphics.drawCircle(dx, dy, distance * zoom * 0.4);
						graphics.endFill();
						if (i<lock.keysUsed) {
							graphics.beginFill(0xffffff);
							graphics.drawCircle(dx, dy, distance * zoom * 0.4-1);
							graphics.endFill();
						}
						dx += cos * distance;
						dy += sin * distance;
					}
				} else {
					graphics.beginFill(0x000000, 0.3);
					gameObject.shape.drawShape(graphics, x, y, angle, zoom);
					graphics.endFill();
				}
			}
		}
		
	}

}