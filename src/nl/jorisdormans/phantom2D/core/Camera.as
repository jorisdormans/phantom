package nl.jorisdormans.phantom2D.core 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.cameraComponents.CameraMover;
	import nl.jorisdormans.phantom2D.cameraComponents.FollowObject;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Camera extends Composite
	{
		public static const M_JUMP_TO:String = "jumpTo";
		public static const M_MOVE_TO:String = "moveTo";
		
	//TO DO: refactor all behavior into camera components
		
		
		//public var restrictToLayer:ObjectLayer;
		//public var restrictHorizontal:Boolean = true;
		//public var restrictVertical:Boolean = true;
		//public var wrapCamera:Boolean = false;
		/**
		 * The GameScreen the camera is looking at
		 */
		public var screen:Screen;
		public var position:Vector3D;
		public var target:Vector3D;
		
		public var angle:Number = 0;
		public var zoom:Number = 1;
		/**
		 * The maximum movement speed along the X and Y axis measured in pixels/second.
		 */
		//public var maxSpeed:Number = 15 * 30;
		/**
		 * The camera's lower movement threshold. If the target is less than this distance away, it will not move.
		 */
		//public var deadZone:Number = 32;
		/**
		 * The camera's current X velocity
		 */
		//public var dx:Number;
		/**
		 * The camera's current Y velocity
		 */
		//public var dy:Number;
		/**
		 * Setting this value will shake the camera for a number of frames
		 */
		//public var shake:int = 0;
		/**
		 * The left corner of the screens visible area.
		 */
		public var left:Number = 0;
		/**
		 * The top corner of the screens visible area.
		 */
		public var top:Number = 0;
		/**
		 * The right corner of the screens visible area.
		 */
		public var right:Number = 0;
		/**
		 * The bottom corner of the screens visible area.
		 */
		public var bottom:Number = 0;
		
		private var mover:CameraMover;
		
		/**
		 * Camera class handle what area of a screen is visible.   
		 * @param	screen     The Screen the camera is focused on
		 * @param	position   The initial camera position
		 */
		public function Camera(screen:Screen, position:Vector3D) 
		{
			super();
			this.screen = screen;
			this.position = position;
			this.target = position.clone();
			
			addComponent(new CameraMover());
			
			//_target = position.clone();
			//_easing = easing;
			//focusOn = null;
			
		}
		
		override public function addComponent(component:Component):Component 
		{
			if (component is CameraMover) {
				if (mover) {
					removeComponent(mover);
				}
				mover = component as CameraMover;
			}
			return super.addComponent(component);
		}
		
		override public function removeComponentAt(index:int):Boolean 
		{
			if (components[index] == mover) {
				mover = null;
			}
			return super.removeComponentAt(index);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			position.x = target.x;
			position.y = target.y;
			left = position.x - screen.screenWidth * 0.5;
			top = position.y - screen.screenHeight * 0.5;
			right = position.x + screen.screenWidth * 0.5;
			bottom = position.y + screen.screenHeight * 0.5;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case M_JUMP_TO:
					target = data.target;
					position.x = target.x;
					position.y = target.y;
					position.z = target.z;
					sendMessage(FollowObject.M_STOP_FOLLOWING);
					break;
				case M_MOVE_TO:
					target = data.target;
					sendMessage(FollowObject.M_STOP_FOLLOWING);
					break;
			}
			return super.handleMessage(message, data);
		}
		
		
		
		
		
		/**
		 * Restricts camera movement to screen's world dimensions and a specified deadZone.
		 * @param	deadZone
		 */
		/*private function limitCamera(deadZone:Number):void {
			//if (_target.x < screen.viewPortWidth * 0.5-deadZone) _target.x = screen.viewPortWidth * 0.5-deadZone;
			//if (_target.x > screen.maxWidth - screen.viewPortWidth * 0.5+deadZone) _target.x = screen.maxWidth - screen.viewPortWidth * 0.5+deadZone;
			//if (_target.y < screen.viewPortHeight * 0.5-deadZone) _target.y = screen.viewPortHeight * 0.5-deadZone;
			//if (_target.y > screen.maxHeight - screen.viewPortHeight * 0.5+deadZone) _target.y = screen.maxHeight - screen.viewPortHeight * 0.5+deadZone;
			if (restrictToLayer && restrictHorizontal && _target.x < screen.screenWidth * 0.5-deadZone) _target.x = screen.screenWidth * 0.5-deadZone
			if (restrictToLayer && restrictHorizontal && _target.x > restrictToLayer.layerWidth - screen.screenWidth * 0.5+deadZone) _target.x = restrictToLayer.layerWidth - (screen.screenWidth * 0.5)+deadZone;
			if (restrictToLayer && restrictVertical && _target.y < screen.screenHeight * 0.5-deadZone) _target.y = screen.screenHeight * 0.5-deadZone
			if (restrictToLayer && restrictVertical && _target.y > restrictToLayer.layerHeight - screen.screenHeight * 0.5 + deadZone) _target.y = restrictToLayer.layerHeight - screen.screenHeight * 0.5 + deadZone;
		}*/
		
		/**
		 * Set the camera focus position to the specified values.
		 * @param	x
		 * @param	y
		 * @param	z
		 */
		/*public function setFocus(x:Number, y:Number, z:Number = 0):void {
			_target.x = x;
			_target.y = y;
			_target.z = z;
			focusOn = null;
			limitCamera(0);
		}*/
		
		/**
		 * Update the camera position. Should be called once during a game's update loop. Called automatically from GameScreen.update.
		 * @param	elapsedTime
		 */
		/*public function update(elapsedTime:Number):void {
			if (focusOn != null) {
				_target.x = focusOn.position.x;
				_target.y = focusOn.position.y;
				_target.z = focusOn.position.z;
				limitCamera(deadZone);
				//limitCamera(0);
			}
			
			if (wrapCamera && restrictToLayer) {
				if (_target.x - _position.x > restrictToLayer.layerWidth * 0.5) {
					_target.x -= restrictToLayer.layerWidth;
				}
				if (_target.x - _position.x < restrictToLayer.layerWidth * -0.5) {
					_target.x += restrictToLayer.layerWidth;
				}
				if (_target.y + _position.y < restrictToLayer.layerHeight * 0.5) {
					_target.y -= restrictToLayer.layerHeight;
				}
				if (_target.y - _position.y < restrictToLayer.layerHeight * -0.5) {
					_target.y += restrictToLayer.layerHeight;
				}
			}
			
			dx = 0;
			dy = 0;
			if (_target.x > _position.x + deadZone) dx = _target.x - (_position.x + deadZone);
			if (_target.x < _position.x - deadZone) dx = _target.x - (_position.x - deadZone);
			if (_target.y > _position.y + deadZone) dy = _target.y - (_position.y + deadZone);
			if (_target.y < _position.y - deadZone) dy = _target.y - (_position.y - deadZone);
			dx = Math.max(Math.min(dx*_easing, maxSpeed), -maxSpeed);
			dy = Math.max(Math.min(dy*_easing, maxSpeed), -maxSpeed);
			
			_position.x += dx * elapsedTime;
			_position.y += dy * elapsedTime;
			
			_position.z = _target.z
			
			if (wrapCamera && restrictToLayer) {
				if (_position.x < 0) _position.x += restrictToLayer.layerWidth;
				if (_position.x > restrictToLayer.layerWidth) _position.x -= restrictToLayer.layerWidth;
				if (_position.y < 0) _position.y += restrictToLayer.layerHeight;
				if (_position.y > restrictToLayer.layerHeight) _position.x -= restrictToLayer.layerHeight;
			}
			
			if (!wrapCamera) {
				if (_position.x < screen.screenWidth * 0.5) _position.x = screen.screenWidth * 0.5;
				if (_position.x > screen.maxWidth - screen.screenWidth * 0.5) _position.x = screen.maxWidth - screen.screenWidth * 0.5;
				if (_position.y < screen.screenHeight * 0.5) _position.y = screen.screenHeight * 0.5;
				if (_position.y > screen.maxHeight - screen.screenHeight * 0.5) _position.y = screen.maxHeight - screen.screenHeight * 0.5;
			}
			
			if (shake > 0) {
				var s:Number = Math.min(5, shake);
				_position.x += Math.random() * s - Math.random() * s;
				_position.y += Math.random() * s - Math.random() * s;
				shake--;
			}
			
			restoreFocus();
		}
		
		public function restoreFocus():void {
			left = _position.x - screen.screenWidth * 0.5;
			top = _position.y - screen.screenHeight * 0.5;
			right = _position.x + screen.screenWidth * 0.5;
			bottom = _position.y + screen.screenHeight * 0.5;
		}
		
		public function setZeroFocus():void {
			left = 0;
			top = 0;
			right = screen.screenWidth;
			bottom = screen.screenHeight;
		}
		
		public function shakeDistance(s:int, x:Number, y:Number):void {
			x = Math.abs(x - _position.x);
			y = Math.abs(y - _position.y);
			if (x + y < 500) s = s;
			else if (x + y < 1500) s = s * (1500 - x + y) / 1000;
			else s = 0;
			if (s > shake) shake = s;
		}*/
		
		/**
		 * Retrieves the current target position.
		 */
		//public function get target():Vector3D { return _target; }
		
		/**
		 * Retrieves the current camera position
		 */
		/*public function get position():Vector3D { return _position; }
		
		public function get easing():Number { return _easing; }
		
		public function set easing(value:Number):void 
		{
			_easing = value;
		}*/
		
		/**
		 * Immediately move the current camera position to the target position
		 * @param	jumpThreshold  The lower distance threshold for the jump to happen.
		 */
		/*public function jumpToTarget(jumpThreshold:Number = -1):void {
			if (focusOn != null) {
				_target.x = focusOn.position.x;
				_target.y = focusOn.position.y;
				limitCamera(0);
			}
			var dx:Number = _position.x - _target.x;
			var dy:Number = _position.y - _target.y;
			if (Math.abs(dx)>jumpThreshold || Math.abs(dy)>jumpThreshold) {
				_position.x = _target.x;
				_position.y = _target.y;
			}
		}
		
		public function moveCamera(dx:Number, dy:Number):void 
		{
			_position.x += dx;
			_position.y += dy;
			
			if (restrictToLayer && restrictHorizontal && _position.x < screen.screenWidth * 0.5) _position.x = screen.screenWidth * 0.5;
			if (restrictToLayer && restrictHorizontal && _position.x > restrictToLayer.layerWidth - screen.screenWidth * 0.5) _position.x = restrictToLayer.layerWidth - (screen.screenWidth * 0.5);
			if (restrictToLayer && restrictVertical && _position.y < screen.screenHeight * 0.5) _position.y = screen.screenHeight * 0.5;
			if (restrictToLayer && restrictVertical && _position.y > restrictToLayer.layerHeight - screen.screenHeight * 0.5) _position.y = restrictToLayer.layerHeight - screen.screenHeight * 0.5;
			
			if (wrapCamera && restrictToLayer) {
				if (_position.x < 0) _position.x += restrictToLayer.layerWidth;
				if (_position.x > restrictToLayer.layerWidth) _position.x -= restrictToLayer.layerWidth;
				if (_position.y < 0) _position.y += restrictToLayer.layerHeight;
				if (_position.y > restrictToLayer.layerHeight) _position.x -= restrictToLayer.layerHeight;
			}			
			restoreFocus();
			
		}*/
		
	}
	
}