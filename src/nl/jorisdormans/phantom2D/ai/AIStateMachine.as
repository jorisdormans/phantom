package nl.jorisdormans.phantom2D.ai 
{
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.ICollisionHandler;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class AIStateMachine extends Component implements ICollisionHandler
	{
		private var states:Vector.<AIState>
		public var eye:AIEye;
		private var defaultState:Class;
		private var instruction:String;
		
		public function AIStateMachine(defaultState:Class = null) 
		{
			super();
			states = new Vector.<AIState>();
			this.defaultState = defaultState;
			instruction = "";
		}
		
		public function addState(state:AIState):void {
			state.stateMachine = this;
			if (states.length > 0) states[states.length - 1].onDeactivate();
			states.push(state);
			state.onActivate();
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			if (states.length > 0) {
				return states[states.length - 1].handleMessage(message, data);
			}
			return super.handleMessage(message, data);
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			while (states.length > 0 && states[states.length - 1].removed) {
				states[states.length - 1].onRemove();
				states.splice(states.length - 1, 1);
				if (states.length > 0) {
					states[states.length - 1].onActivate();
				}
			}
			if (states.length > 0) {
				states[states.length - 1].update(elapsedTime);
			} else if (defaultState) {
				addState(new defaultState() as AIState);
				if (instruction != "") {
					states[0].doInstruction(instruction);
				}
			}
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			eye = gameObject.getComponentByClass(AIEye) as AIEye;
		}
		
		override public function onRemove():void 
		{
			super.onRemove();
			eye = null;
		}
		
		override public function setXML(xml:XML):void 
		{
			super.setXML(xml);
			xml.@aiInstruction = instruction;
		}
		
		override public function readXML(xml:XML):void 
		{
			super.readXML(xml);
			if (xml.@aiInstruction.length() > 0) {
				instruction = xml.@aiInstruction;
			} else {
				instruction = "";
			}
		}
		
		/* INTERFACE nl.jorisdormans.phantom2D.objects.ICollisionHandler */
		
		public function canCollideWith(other:GameObject):Boolean 
		{
			return true;
		}
		
		public function afterCollisionWith(other:GameObject):void 
		{
			if (states.length > 0) {
				states[states.length - 1].afterCollisionWith(other);
			}
			
		}
		
		
	}

}