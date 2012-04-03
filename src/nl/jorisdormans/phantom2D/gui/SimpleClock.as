package nl.jorisdormans.phantom2D.gui 
{
	import fridgegame.FridgeScreen;
	import fridgegame.layers.Hud;
	import nl.jorisdormans.phantom2D.core.Component;
	import nl.jorisdormans.phantom2D.core.Composite;
	import nl.jorisdormans.phantom2D.core.InputState;
	import nl.jorisdormans.phantom2D.core.Layer;
	import nl.jorisdormans.phantom2D.objects.IInputHandler;
	import nl.jorisdormans.phantom2D.objects.ObjectLayer;
	/**
	 * ...
	 * @author Maarten Dijkstra
	 */
	public class SimpleClock extends Component implements IInputHandler 
	{
		
		private var t_hrs:int = 0;
		private var t_mins:int = 0;
		private var t_secs:int = 0;
		private var t_msecs:Number = 0;
		private var time:String = "00:00:00";
		private var totalTime:Number = 0;
		private var go:Boolean = false;
		private var _layer:FridgeScreen;
		
		public function SimpleClock() 
		{
			//trace("SimpleClock: clock added");
		}
		
		public function handleInput(elapsedTime:Number, currentState:InputState, previousState:InputState):void 
		{
			if (go) {
				t_msecs += (elapsedTime*10);
				totalTime += (elapsedTime*10);
				//trace("SimpleClock: "+t_msecs);
				if (t_msecs >= 10)
				{
					t_msecs = 0;
					t_secs++;
				}
				if (t_secs >= 60)
				{
					t_secs = 0;
					t_mins++;
				}
				updateTime();
			}
		}
		
		private function updateTime():void
		{
			time = "";
			time+= (t_mins > 9) ? (t_mins.toString()) : ("0" + t_mins.toString());
			time+= ":";
			time+= (t_secs > 9) ? (t_secs.toString()) : ("0" + t_secs.toString());
			time+= ":";
			time += (round(t_msecs, 0) > 9) ? (round(t_msecs, 0).toString()) : (round(t_msecs ,0).toString() + "0");
			//trace("SimpleClock: "+time);
			_layer.hud.timeText.text = time;
		}
		
		public function getTimeString():String 
		{
			return time;
		}
		
		public function getTimeNum():Number
		{
			return round(totalTime, 1);
		}
		
		public function start():void
		{
			//trace("SimpleClock: clock start");
			go = true;
		}
		
		public function stop():void
		{
			//trace("SimpleClock: clock stop");
			go = false;
		}
		
		public function reset():void {
			//trace("SimpleClock: clock reset");
			//time.reset();
			t_hrs = 0;
			t_mins = 0;
			t_secs = 0;
			t_msecs = 0;
			totalTime = 0;
			updateTime();
		}
		
		private function round(num:Number, precision:int):Number{
			var decimal:Number = Math.pow(10, precision);
			return Math.round(decimal* num) / decimal;
		}
		
		override public function onAdd(composite:Composite):void 
		{
			super.onAdd(composite);
			_layer = composite as FridgeScreen;
			if (!_layer) {
				throw new Error("Clock added to Composite that is not an ObjectLayer");
			} else {
				_layer.hud.timeText.text = time;
			}
		}
	}

}