package nl.jorisdormans.phantomGUI 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class PhantomDrawControl extends PhantomControl
	{
		protected var _hover:Boolean = false;
		protected var _selected:Boolean = false;
		private var _mouseDownX:Number;
		private var _mouseDownY:Number;
		private var _moving:Boolean;
		public var onSelect:Function;
		public var onDeselect:Function;
		public var onMove:Function;
		public var onEndMove:Function;
		public var rotationPointX:Number;
		public var rotationPointY:Number;
		public var tag:int = -1;
		
		public function PhantomDrawControl(onMove:Function, onEndMove:Function, parent:DisplayObjectContainer, x:Number, y:Number) 
		{
			super(parent, x, y, PhantomGUISettings.drawControlSize, PhantomGUISettings.drawControlSize);
			addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.onMove = onMove;
			this.onEndMove = onEndMove;
		}
		
		public function onMouseDown(e:MouseEvent):void 
		{
			if (!e.shiftKey /*&& !selected*/) {
				if (parent != null) {
					var i:int = 0;
					while (i < parent.numChildren) {
						var dc:PhantomDrawControl = parent.getChildAt(i) as PhantomDrawControl;
						if (dc != null && dc.selected && dc!=this) {
							dc.selected = false;
						}
						i++;
					}
				}
			}
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_mouseDownX = e.stageX;
			_mouseDownY = e.stageY;
			_moving = false;
			selected = true;
			parent.setChildIndex(this, parent.numChildren-1);
		}
		
		private function onMouseMove(e:MouseEvent):void 
		{
			if (e.target != this && e.target != this.parent) return;
			var dx:Number = e.stageX - _mouseDownX;
			var dy:Number = e.stageY - _mouseDownY;
			var rotate:Boolean = false;
			if (e.ctrlKey && (rotationPointX != _controlX || rotationPointY != _controlY)) rotate = true;
			
			if (rotate) {
				//fix length to rotation point
				var dx2:Number = _controlX - rotationPointX;
				var dy2:Number = _controlY - rotationPointY;
				var l:Number = Math.sqrt(dx2 * dx2 + dy2 * dy2);
				dx2 += dx;
				dy2 += dy;
				var a:Number = Math.atan2(dy2, dx2);
				dx = rotationPointX + Math.cos(a) * l - _controlX;
				dy = rotationPointY + Math.sin(a) * l - _controlY;
			}
			
			if (parent is PhantomDrawPanel && !rotate) {
				var p:Point = (parent as PhantomDrawPanel).trySnap(_controlX+dx, _controlY+dy);
				dx += p.x;
				dy += p.y;
			}
			if (!_moving) {
				if (dx * dx + dy * dy > 25) _moving = true;
			}
			if (_moving) {
				
				if (e.shiftKey && !rotate) {
					if (Math.abs(dx) > Math.abs(dy)) dy = 0;
					else dx = 0;
				}
				if (parent != null) {
					var i:int = 0;
					while (i < parent.numChildren) {
						var dc:PhantomDrawControl = parent.getChildAt(i) as PhantomDrawControl;
						if (dc != null && dc.selected) {
							if (parent is PhantomDrawPanel) {
								dc.x = Math.min((parent as PhantomDrawPanel).controlWidth - 1, Math.max(0, dc._controlX + dx));
								dc.y = Math.min((parent as PhantomDrawPanel).controlHeight - 1, Math.max(0, dc._controlY + dy));
							} else {
								dc.x = dc._controlX + dx;
								dc.y = dc._controlY + dy;
							}
							if (dc.onMove != null) dc.onMove(dc);
						}
						i++;
					}
				}
			}
		}
		
		private function onMouseUp(e:MouseEvent):void 
		{
			if (stage == null) return;
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			if (parent != null) {
				var i:int = 0;
				while (i < parent.numChildren) {
					var dc:PhantomDrawControl = parent.getChildAt(i) as PhantomDrawControl;
					if (dc != null && dc.selected) {
						dc.setPosition(dc.x, dc.y);
						if (dc.onEndMove != null) dc.onEndMove(dc);
					}
					i++;
				}
			}
		}
		
		private function onMouseOver(e:MouseEvent):void 
		{
			addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			hover = true;
		}
		
		private function onMouseOut(e:MouseEvent):void 
		{
			removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			hover = false;
			
		}
		
		override public function draw():void 
		{
			graphics.clear();
			graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorDrawControlOutline, 0.0);
			graphics.drawCircle(0.5, 0.5, PhantomGUISettings.drawControlSize);
			graphics.endFill();
			graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorDrawControlOutline, 1);
			graphics.drawCircle(0.5, 0.5, PhantomGUISettings.drawControlSize);
			graphics.drawCircle(0.5, 0.5, PhantomGUISettings.drawControlSize-3);
			graphics.endFill();
			if (_selected) graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorDrawControlSelected);
			else if (_hover) graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorDrawControlHover);
			else graphics.beginFill(PhantomGUISettings.colorSchemes[colorScheme].colorDrawControl);
			graphics.drawCircle(0.5, 0.5, PhantomGUISettings.drawControlSize-0.5);
			graphics.drawCircle(0.5, 0.5, PhantomGUISettings.drawControlSize-2.5);
			graphics.endFill();
		}
		
		public function get hover():Boolean { return _hover; }
		
		public function set hover(value:Boolean):void 
		{
			_hover = value;
			draw();
		}
		
		public function get selected():Boolean { return _selected; }
		
		public function set selected(value:Boolean):void 
		{
			if (_selected == value) return;
			_selected = value;
			if (_selected && onSelect != null) onSelect(this);
			if (!_selected && onDeselect != null) onDeselect(this);
			draw();
		}
		
		override public function setPosition(x:Number, y:Number):void 
		{
			super.setPosition(x, y);
			rotationPointX = x;
			rotationPointY = y;
		}
		
		
		
	}

}