package nl.jorisdormans.phantom2D.prefabs.players
{
	import flash.display.Graphics;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public interface IHudComponent 
	{
		function drawToHud(graphics:Graphics):void;
	}
	
}