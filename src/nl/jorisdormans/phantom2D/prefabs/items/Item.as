package nl.jorisdormans.phantom2D.prefabs.items 
{
	import flash.display.Graphics;
	import flash.geom.Vector3D;
	import nl.jorisdormans.phantom2D.core.Phantom;
	import nl.jorisdormans.phantom2D.objects.GameObject;
	import nl.jorisdormans.phantom2D.objects.IRenderable;
	/**
	 * ...
	 * @author Joris Dormans
	 */
	public class Item extends GameObject
	{
		public static var pickUpTimeOut:Number = 0.3;
		
		public var maxQuantity:int;
		public var quantity:int;
		public var itemName:String;
		public var unique:Boolean;
		private var droppedBy:GameObject;
		private var justDropped:Number;
		public var equipedBy:GameObject;
		
		protected var angle:Number;
		protected var drawX:Number;
		protected var drawY:Number;
		protected var zoom:Number;
		
		
		public function Item() 
		{
			angle = 0;
			drawX = 0;
			drawY = 0;
			zoom = 1;
			unique = false;
			maxQuantity = 1;
			quantity = 1;
			equipedBy = null;
			justDropped = 0;
			droppedBy = null;
			itemName = "an item";
		}
		
		override public function canCollideWith(other:GameObject):Boolean 
		{
			if (other == equipedBy) return false;
			return super.canCollideWith(other);
		}
		
		override public function afterCollisionWith(other:GameObject):void 
		{
			if (justDropped > 0 && other == droppedBy) {
				justDropped = pickUpTimeOut;
			} else {
				other.sendMessage("add item", { item:this } );
			}			
			super.afterCollisionWith(other);
		}
		
		public function drawInInventory(graphics:Graphics, x:Number, y:Number):void {
			var l:int = components.length;
			for (var i:int = 0; i < l; i++) {
				if (components[i] is IRenderable) {
					(components[i] as IRenderable).render(graphics, x + drawX, y + drawY, angle, zoom);
				}
			}
		}
		
		override public function update(elapsedTime:Number):void 
		{
			justDropped -= Math.min(justDropped, elapsedTime);
			super.update(elapsedTime);
		}
		
		public function useItem(usedBy:GameObject):Boolean {
			//to be overridden
			return false;
		}
		
		public function endUseItem(usedBy:GameObject):Boolean {
			//to be overridden
			return false;
		}
		
		public function drop(position:Vector3D, droppedBy:GameObject):void {
			this.droppedBy = droppedBy;
			justDropped = pickUpTimeOut; 
			this.position = position;
			if (droppedBy && droppedBy.layer) droppedBy.layer.addGameObjectSorted(this);
			equipedBy = null;
			placeOnTile();
		}
		
		public function equip(equipedBy:GameObject):void {
			if (this.equipedBy != null) return;
			if (equipedBy.sendMessage("equip", { item:this } ) > Phantom.MESSAGE_NOT_HANDLED ) {
				this.equipedBy = equipedBy;
			}
		}
		
		public function unequip():void {
			if (equipedBy == null) return;
			equipedBy.sendMessage("unequip", { item:this } );
			equipedBy = null;
		}
		
		public function canPickUp(gameObject:GameObject):Boolean {
			return true;
		}
		
		public function onPickUp(gameObject:GameObject):void {
			
		}
		
		
		
		
		
		
		
		
	}

}