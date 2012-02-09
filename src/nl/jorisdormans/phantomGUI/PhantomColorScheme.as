package nl.jorisdormans.phantomGUI 
{
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomColorScheme
	{
		public var colorFont:uint = 0x000055;
		public var colorWindow:uint = 0xffffff;
		public var colorWindowDisabled:uint = 0xbbbbff;
		public var colorFace:uint = 0xbbbbff;
		public var colorFaceHover:uint = 0xddddff
		public var colorFaceDisabled:uint = 0x8888bb;
		public var colorBorder:uint = 0x000055;
		public var colorBorderDisabled:uint = 0x555588;
		public var colorDrawControlOutline:uint = 0xffffff;
		public var colorDrawControl:uint = 0x000000;
		public var colorDrawControlHover:uint = 0x880000;
		public var colorDrawControlSelected:uint = 0xff0000;
		
		public function PhantomColorScheme() 
		{
			setColors();
		}
		
		public function setColors(face:uint = 0xbbbbff, faceHover:uint = 0xddddff, faceDisable:uint = 0x8888bb, border:uint = 0x000055, borderDisabled:uint = 0x555588, font:uint = 0x000055, window:uint = 0xffffff, windowDisabled:uint = 0xbbbbff, drawControl:uint = 0x000000, drawControlOutline:uint = 0xffffff, drawControlHover:uint =0x880000, drawControlSelected:uint = 0xff0000):void {
			colorFont = font;
			colorWindow = window;
			colorWindowDisabled = windowDisabled
			colorFace = face;
			colorFaceHover = faceHover
			colorFaceDisabled = faceDisable;
			colorBorder = border;
			colorBorderDisabled = borderDisabled;
			colorDrawControlOutline = drawControlOutline;
			colorDrawControl = drawControl;
			colorDrawControlHover = drawControlHover;
			colorDrawControlSelected = drawControlSelected;			
		}
		
		
	}

}