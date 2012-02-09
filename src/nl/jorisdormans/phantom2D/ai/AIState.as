package nl.jorisdormans.phantom2D.ai 
{
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.util.StringUtil;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AIState 
	{
		public var stateMachine:AIStateMachine;
		public var removed:Boolean;
		
		public function AIState() 
		{
			removed = false;
			stateMachine = null;
		}
		
		public function onActivate():void {
			
		}
		
		public function onDeactivate():void {
			
		}
		
		public function onRemove():void {
			stateMachine = null;
		}
		
		public function update(elapsedTime:Number):void {
			
		}
		
		public function handleMessage(message:String, data:Object = null):int {
			return Phantom.MESSAGE_NOT_HANDLED;
		}
		
		public function doInstruction(instruction:String):void 
		{
			//to be overriden
		}
		
		public function afterCollisionWith(other:GameObject):void 
		{
			
		}
		
	}

}