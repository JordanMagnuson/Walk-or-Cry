package game
{
	import game.Item;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import rooms.MyWorld;
	import game.fjords.Ocean;
	
	public class MountainEnd extends Item
	{	
		/**
		 * Graphics
		 */
		[Embed(source = "../../assets/fjords/large_mountain_end.png")] private const END_MOUNTAIN:Class;	
		
		public function MountainEnd() 
		{
			rawSprite = END_MOUNTAIN;
			super(rawSprite, 'far', true);
			image.flipped = false;		// We don't want this mountian to be flipped--we have it oriented just the way we want it.
			layer = 90;					// End mountian should be in front of all other mountains and clouds.
			if ((FP.world as MyWorld).location.type == 'fjords') 
			{
				y = Ocean.Y_TOP;
				type = 'elevated_mountain';
			}			
		}
		
		override public function update():void 
		{
			super.update();
			
			// When end mountain is centered on screen, we want to stop the world scrolling, and enter the end sequence.
			if (!Global.worldStopped && x < 50) {	// Hardcode when the mountain is centered on screen.
				Global.worldStopped = true;
				trace('world stopped');
			}
		}
	}
}