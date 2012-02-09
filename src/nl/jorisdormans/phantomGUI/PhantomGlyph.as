package nl.jorisdormans.phantomGUI 
{
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomGlyph
	{
		public static const CHECK:int = 1;
		public static const PLAY:int = 2;
		public static const STOP:int = 3;
		public static const ARROW_LEFT:int = 10;
		public static const ARROW_RIGHT:int = 11;
		public static const ARROW_UP:int = 12;
		public static const ARROW_DOWN:int = 13;
		
		public function PhantomGlyph() 
		{
		}
		
		public static function drawGlyph(graphics:Graphics, glyph:int, x:Number, y:Number, size:Number):void {
			var commands:Vector.<int> = new Vector.<int>();
			var data:Vector.<Number> = new Vector.<Number>();
			switch (glyph) {
				default:
					return;
				case CHECK:
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x + size * 0.0, y + size * 0.1);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.5, y - size * 0.5);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.0, y + size * 0.4);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x - size * 0.3, y - size * 0.2);
					break;
				case PLAY:
				case ARROW_RIGHT:
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x - size * 0.3, y - size * 0.4);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.3, y - size * 0.0);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x - size * 0.3, y + size * 0.4);
					break;
				case ARROW_LEFT:
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x + size * 0.3, y + size * 0.4);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x - size * 0.3, y - size * 0.0);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.3, y - size * 0.4);
					break;
				case ARROW_UP:
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x + size * 0.4, y + size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x - size * 0.4, y + size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.0, y - size * 0.3);
					break;
				case ARROW_DOWN:
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x - size * 0.4, y - size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.4, y - size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.0, y + size * 0.3);
					break;
				case STOP:
					commands.push(GraphicsPathCommand.MOVE_TO);
					data.push(x - size * 0.3, y - size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.3, y - size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x + size * 0.3, y + size * 0.3);
					commands.push(GraphicsPathCommand.LINE_TO);
					data.push(x - size * 0.3, y + size * 0.3);
					break;
			}
			
			graphics.drawPath(commands, data);
		}
		
	}

}