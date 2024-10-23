package game.fjords 
{
	import flash.utils.Endian;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.ColorTween;
	import game.Colors;
	
	/**
	 * ...
	 * @author Jordan Magnuson
	 */
	public class Ocean extends Entity
	{
		public static const Y_TOP:Number = 152;					// Top of the ocean.
		public static const FADE_IN_DURATION:Number = 8;
		public static const FADE_OUT_DURATION:Number = 8;
		
		public var fadeTween:ColorTween;
		public var locationEnded:Boolean = false;	// If the location that this ocean is attached to has ended. (Time to think about fading out ocean.)
		public var fadingOut:Boolean = false;
		
		/**
		 * Direction is 1 or -1, makes the wase move back and forth;
		 */
		public var direction:int = 1;
		
		/**
		 * Graphics
		 */
		[Embed(source="../../../assets/fjords/ocean.png")] private const SPRITE01:Class;	
		public var image:Image = new Image(SPRITE01);
		
		public function Ocean() 
		{
			graphic = image;
			image.alpha = 0;
			type = 'ocean';
			layer = 900;
			
			// Hit box to bottom left
			image.originX = 0;
			image.originY = image.height;
			image.x = 0;
			image.y = -image.originY;	
			
			setHitbox(image.width, image.height, image.originX, image.originY);		
			
			x = 0;
			y = FP.screen.height;
		}
		
		override public function added():void
		{
			fadeIn();
		}
		
		override public function update():void
		{
			super.update();
			(graphic as Image).alpha = fadeTween.alpha;
			
			if (locationEnded && !fadingOut) 
			{
				// Once location has ended, check to see if there are any elevated mountains present.
				// If so, wait for these to go offscreen before fading out ocean. (Otherwise elevated mountains are left hanging in air.)
				var elevatedMountainCount:uint = FP.world.typeCount('elevated_mountain');
				FP.console.log("location ended. Elevated mountain count: " + elevatedMountainCount);
				if (elevatedMountainCount == 0) {
					trace('no more elevated mountains. fade out ocean');
					fadeOut();
					fadingOut = true;
				}
			}
		}		
		
		public function fadeIn():void
		{
			fadeTween = new ColorTween();
			addTween(fadeTween);		
			fadeTween.tween(FADE_IN_DURATION, Colors.WHITE, Colors.WHITE, 0, 1);
		}			
		
		public function fadeOut():void
		{
			removeTween(fadeTween);
			fadeTween = new ColorTween(destroy);
			addTween(fadeTween);		
			fadeTween.tween(FADE_OUT_DURATION, Colors.WHITE, Colors.WHITE, image.alpha, 0);			
		}		
		
		public function destroy():void
		{
			FP.world.remove(this);
		}
	}

}