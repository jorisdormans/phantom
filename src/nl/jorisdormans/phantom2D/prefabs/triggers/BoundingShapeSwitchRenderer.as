package nl.jorisdormans.phantom2D.prefabs.triggers
{
	import flash.display.Graphics;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	import nl.jorisdormans.phantom2D.util.DrawUtil;
	import nl.jorisdormans.phantom2D.util.MathUtil;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class BoundingShapeSwitchRenderer extends Component implements IRenderable
	{
		private var colorOn:uint;
		private var colorOff:uint;
		private var color:uint;
		private var glow:Number;
		private var glowSpeed:Number;
		private var state:int;
		
		public function BoundingShapeSwitchRenderer(colorOn:uint, colorOff:uint, state:int = 0, glowSpeed:Number = 2)
		{
			this.colorOn = colorOn;
			this.colorOff = colorOff;
			state = Math.min(Math.max(state, 0), 1);
			color = (state == 0) ? colorOff : colorOn;
			this.state = state;
			this.glow = state;
			this.glowSpeed = glowSpeed;
		}
		
		override public function update(elapsedTime:Number):void
		{
			var d:Number = Math.max(Math.min(state - glow, glowSpeed * elapsedTime), -glowSpeed * elapsedTime);
			if (d != 0)
			{
				glow += d;
				color = DrawUtil.lerpColor(colorOff, colorOn, MathUtil.easeCos(glow));
			}
			super.update(elapsedTime);
		}
		
		override public function handleMessage(message:String, data:Object = null):int
		{
			switch (message)
			{
				case "activate": 
					state = 1;
					return Phantom.MESSAGE_HANDLED;
				case "deactivate": 
					state = 0;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		override public function readXML(xml:XML):void
		{
			if (xml.@colorOn.length() > 0)
				colorOn = StringUtil.toColor(xml.@colorOn);
			if (xml.@colorOff.length() > 0)
				colorOff = StringUtil.toColor(xml.@colorOff);
			if (xml.@glowSpeed.length() > 0)
				glowSpeed = xml.@glowSpeed;
			if (xml.@activated == "1")
			{
				glow = state = 1;
				color = colorOn;
			}
			if (xml.@activated == "0")
			{
				glow = state = 0;
				color = colorOff;
			}
			super.readXML(xml);
		}
		
		override public function setXML(xml:XML):void
		{
			xml.@glowSpeed = glowSpeed;
			xml.@colorOn = StringUtil.toColorString(colorOn);
			xml.@colorOff = StringUtil.toColorString(colorOff);
			super.setXML(xml);
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.IRenderable */
		
		public function render(graphics:Graphics, x:Number, y:Number, angle:Number = 0, zoom:Number = 1):void
		{
			graphics.beginFill(color);
			gameObject.shape.drawShape(graphics, x, y, angle + gameObject.shape.orientation, zoom);
			graphics.endFill();
		}
		
		public function setColorOff(color:uint):void
		{
			this.color = color;
		}
	}

}