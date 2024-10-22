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
		
		public static const FADE_IN_DURATION:Number = 12;
		public static const FADE_OUT_DURATION:Number = 8;
		
		public const SPEED:Number = 10;
		
		public var fadeTween:ColorTween;
		
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