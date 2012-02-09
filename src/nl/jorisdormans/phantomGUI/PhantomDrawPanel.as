package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomDrawPanel extends PhantomControl
	{
		public var background:uint = 0x4488ff;
		public var foreground:uint = 0x0044cc;
		public var gridX:Number = 40;
		public var gridY:Number = 40;
		public var snapDistance:Number = 5;
		private var _maskShape:Sprite;
		
		public function PhantomDrawPanel(parent:DisplayObjectContainer, x:Number, y:Number, width:Number, height:Number, showing:Boolean = true, enabled:Boolean = true) 
		{
			super(parent, x, y, width, height, showing, enabled);
			setSize(width, height);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		protected function onMouseDown(e:MouseEvent):void 
		{
			if (e.target == this) {
				var i:int = 0;
				while (i < numChildren) {
					var dc:PhantomDrawControl = getChildAt(i) as PhantomDrawControl;
					if (dc != null && dc.selected) dc.selected = false;
					i++;
				}
			}
		}
		
		override public function setSize(width:Number, height:Number):void 
		{
			super.setSize(width, height);
			if (_maskShape != null && _maskShape.parent != null) _maskShape.parent.removeChild(_maskShape);
			_maskShape = new Sprite();
			//_maskShape.x = getStageX();
			//_maskShape.y = getStageY();
			addChild(_maskShape);
			_maskShape.graphics.clear();
			_maskShape.graphics.beginFill(0xff0000);
			_maskShape.graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			_maskShape.graphics.endFill();
			mask = _maskShape;
			draw();			
		}
		
		override public function draw():void 
		{
			graphics.clear();
			graphics.beginFill(background);
			graphics.drawRect(0, 0, _controlWidth, _controlHeight);
			graphics.endFill();
			
			if (gridX > 0) {
				var x:Number = 0;
				while (x < _controlWidth) {
					graphics.beginFill(foreground);
					graphics.drawRect(x, 0, 1, _controlHeight);
					x += gridX;
					graphics.endFill();
				}
			}
			
			if (gridY > 0) {
				var y:Number = 0;
				while (y < _controlHeight) {
					graphics.beginFill(foreground);
					graphics.drawRect(0, y, _controlWidth, 1);
					y += gridY;
					graphics.endFill();
				}
			}
		}
		
		public function trySnap(x:Number, y:Number):Point {
			var dx:Number = 0;
			var dy:Number = 0;
			//snap to grid
			if (gridX > 0) {
				dx = x % gridX;
				if (dx > gridX * 0.5) dx -= gridX;
				dx *= -1;
				if (Math.abs(dx) > snapDistance) dx = 0;
			}
			if (gridY > 0) {
				dy = y % gridY;
				if (dy > gridY * 0.5) dy -= gridY;
				dy *= -1;
				if (Math.abs(dy) > snapDistance) dy = 0;
			}
			
			return new Point(dx, dy);
		}
		
	}

}