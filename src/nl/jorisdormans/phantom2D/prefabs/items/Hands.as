package nl.jorisdormans.phantom2D.prefabs.items 
{
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Hands extends Component
	{
		private var armLength:Number;
		private var number:int;
		private var angle:Number;
		private var carrying:Vector.<Item>;
		private var itemCount:int;
		private var twist:Number;
		private var realTwist:Number;
		private var firingBow:Number;
		private var realFiringBow:Number;
		
		public function Hands(number:int, armLength:Number, angle:Number) 
		{
			this.number = number;
			this.armLength = armLength;
			this.angle = -angle;
			carrying = new Vector.<Item>();
			for (var i:int = 0; i < number; i++) {
				carrying.push(null);
			}
			itemCount = 0;
			twist = 0;
			realTwist = 0;
			firingBow = 0;
			realFiringBow = 0;
		}
		
		override public function handleMessage(message:String, data:Object = null):int 
		{
			switch (message) {
				case "start firing bow":
					firingBow = 1;
					break;
				case "end firing bow":
					firingBow = 0;
					break;
				case "equip":
					if (equip(data.item as Item)) return Phantom.MESSAGE_CONSUMED;
					break;
				case "unequip":
					if (unequip(data.item as Item)) return Phantom.MESSAGE_CONSUMED;
					break;
				case "has free hand":
					for (var i:int = 0; i < number; i++) {
						if (!carrying[i]) return Phantom.MESSAGE_CONSUMED;
					}
					break;
				case "twist":
					if (data.angle) twist = data.angle;
					else twist = 0;
					return Phantom.MESSAGE_HANDLED;
			}
			return super.handleMessage(message, data);
		}
		
		private function equip(item:Item):Boolean {
			for (var i:int = 0; i < number; i++) {
				if (carrying[i] == null) {
					carrying[i] = item;
					gameObject.layer.addGameObjectSorted(item);
					//call update to make sure the location of the added item is updated immediately
					update(0);
					itemCount++;
					return true;
				}
			}
			return false;
		}
		
		private function unequip(item:Item):Boolean {
			for (var i:int = 0; i < number; i++) {
				if (carrying[i] == item) {
					item.removed = true;
					carrying[i] = null;
					itemCount--;
					return true;
				}
			}
			return false;
		}
		
		override public function update(elapsedTime:Number):void 
		{
			super.update(elapsedTime);
			realTwist = twist * 0.3 + realTwist * 0.7;
			realFiringBow = firingBow * 0.3 + realFiringBow * 0.7;
			for (var i:int = 0; i < number; i++) {
				if (carrying[i] != null) {
					var a:Number = 0;
					if (itemCount > 1) {
						a = (1 + i / 2) * ((i % 2) * 2 - 1) * angle;
					}
					a *= (1 - realFiringBow);
					
					a += gameObject.shape.orientation + realTwist;
					var cos:Number = Math.cos(a);
					var sin:Number = Math.sin(a);
					carrying[i].shape.setOrientation(a);
					carrying[i].position.x = gameObject.position.x + cos * armLength;
					carrying[i].position.y = gameObject.position.y + sin * armLength;
					carrying[i].position.z = gameObject.position.z;
					carrying[i].placeOnTile();
				}
			}
		}
		
		public function useItem(hand:int):Item {
			if (hand>=0 && hand<number && carrying[hand]) {
				if (carrying[hand].useItem(gameObject)) return carrying[hand];
			}
			return null;
		}
		
		public function getOtherItem(item:Item):Item {
			if (number>1) {
				if (carrying[0] == item) {
					return (carrying[1]);
				}
				if (carrying[1] == item) {
					return (carrying[0]);
				}
			}
			return null;
		}
		
		
		
		
		
	}

}