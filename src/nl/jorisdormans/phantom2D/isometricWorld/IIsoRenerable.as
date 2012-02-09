package nl.jorisdormans.phantom2D.isometricWorld 
{
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public interface IIsoRenerable 
	{
		function renderIso(graphics:Graphics, x:Number, y:Number, angle:Number, isoX:Number, isoY:Number, isoZ:Number):void
	}
	
}