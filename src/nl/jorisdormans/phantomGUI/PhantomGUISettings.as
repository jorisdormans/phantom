package nl.jorisdormans.phantomGUI 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomGUISettings
	{
		//public static var colorFont:uint = 0x000055;
		//public static var colorWindow:uint = 0xffffff;
		//public static var colorWindowDisabled:uint = 0xbbbbff;
		//public static var colorFace:uint = 0xbbbbff;
		//public static var colorFaceHover:uint = 0xddddff
		//public static var colorFaceDisabled:uint = 0x8888bb;
		//public static var colorBorder:uint = 0x000055;
		//public static var colorBorderDisabled:uint = 0x555588;
		//public static var colorDrawControlOutline:uint = 0xffffff;
		//public static var colorDrawControl:uint = 0x000000;
		//public static var colorDrawHover:uint = 0x880000;
		//public static var colorDrawSelected:uint = 0xff0000;
		
		public static var colorSchemes:Vector.<PhantomColorScheme>;
		public static var press:Number = 1;
		public static var fontName:String = "Tahoma";
		public static var fontNameFixed:String = "Courier New";
		public static var fontSize:Number = 11;
		public static var fontSizeFixed:Number = 12;
		public static var borderWidth:Number = 2;
		public static var cornerOuter:Number = 10;
		public static var cornerInner:Number = 9;
		public static var drawControlSize:Number = 7;
		
		public static var colorVeil:uint = 0xffffff;
		public static var veilAlpha:Number = 0.5;
		
		
		colorSchemes = new Vector.<PhantomColorScheme>();
		colorSchemes.push(new PhantomColorScheme());
		
		public function PhantomGUISettings() 
		{
		}
		
		public static function drawCheck(graphics:Graphics, x:Number, y:Number, size:Number):void {
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			commands.push(GraphicsPathCommand.MOVE_TO);
			data.push(x+size*0.0, y + size * 0.1);
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x+size*0.5, y - size * 0.5);
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x+size*0.0, y + size * 0.4);
			commands.push(GraphicsPathCommand.LINE_TO);
			data.push(x-size*0.3, y - size * 0.2);
			commands.push(GraphicsPathCommand.MOVE_TO);
			data.push(x + size * 0.0, y + size * 0.2);
			graphics.drawPath(commands, data);
		}
		
	}

}