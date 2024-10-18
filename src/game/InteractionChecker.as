package game
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import rooms.MyWorld;
	
	/**
	 * ...
	 * @author Jordan Magnuson
	 */
	public class InteractionChecker extends Entity
	{
		public static var timePassed:Number = 0;
		public static var minutesPassed:Number = 0;
		public static var secondsPassed:Number = 0;
		
		public function InteractionChecker() 
		{
			
		}
		
		override public function update():void
		{
			if (Input.check(Key.ANY)) 
			{
				timePassed = 0;
			}
			
			if (Player.startedWalking && timePassed > 10) 
			{
				(FP.world as MyWorld).restart();
			}			
			
			timePassed += FP.elapsed;
			minutesPassed = Math.floor(timePassed / 60);
			secondsPassed = Math.floor(timePassed % 60);
			super.update();
		}
		
	}

}