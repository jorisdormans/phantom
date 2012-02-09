package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomToolTip extends TextField
	{
		private var timer:Timer;
		private var _parent:DisplayObjectContainer;
		
		public function PhantomToolTip(label:String, parent:DisplayObjectContainer) 
		{
			super();
			defaultTextFormat = new TextFormat(PhantomGUISettings.fontName, PhantomGUISettings.fontSize);
			text = label;
			width = textWidth + 5;
			height = textHeight + 5;
			border = true;
			borderColor = PhantomGUISettings.colorSchemes[0].colorBorder;
			background = true;
			backgroundColor = PhantomGUISettings.colorSchemes[0].colorFaceHover;
			textColor = PhantomGUISettings.colorSchemes[0].colorBorder;
			timer = new Timer(1000, 1);
			timer.addEventListener(TimerEvent.TIMER, onTimer); 
			timer.start();
			_parent = parent;
			mouseEnabled = false;
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			if (!parent) {
				_parent.addChild(this); 
				x = stage.mouseX;
				y = stage.mouseY-12;
			}
		}
		
		public function show(x:Number, y:Number):void {
			if (!parent) {
				_parent.addChild(this); 
				this.x = x;
				this.y = y;
			}
			
		}
		
		public function dispose():void {
			timer.stop();
			if (parent != null) parent.removeChild(this);
			
		}
		
	}

}