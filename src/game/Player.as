package game
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import rooms.MyWorld;
	
	public class Player extends Entity
	{
		/**
		 * Player speed determines how fast items approach,
		 * as well as animation speed. 100 is normal.
		 */
		public static const SPEED:Number = 100;
		public var animSpeed:Number;
		
		public static var walking:Boolean = false;
		public static var startedWalking:Boolean = false;
		public static var sleeping:Boolean = false;
		
		public static const DEFAULT_ZZZ_INTERVAL:Number = 1;
		public var zzzAlarm:Alarm = new Alarm(DEFAULT_ZZZ_INTERVAL, releaseZZZ);
		
		/**
		 * Player graphic
		 */
		//[Embed(source='../../assets/walking_spritesheet.png')] private const PLAYER:Class;
		//public var sprPlayer:Spritemap = new Spritemap(PLAYER, 32, 17);
		[Embed(source='../../assets/walking_frontpack_spritesheet.png')] private const PLAYER:Class;
		public var sprPlayer:Spritemap = new Spritemap(PLAYER, 10, 17);			
		
		/**
		 * Sound
		 */
		[Embed(source='../../assets/sounds.swf', symbol='walking.wav')] private const SND_WALKING:Class;
		public var sndWalking:Sfx = new Sfx(SND_WALKING);			
		
		public function Player() 
		{
			// Graphic
			sprPlayer.add("stand", [0], 20, false);
			animSpeed = Player.SPEED / 10;
			sprPlayer.add("walk", [0, 1, 2, 3], animSpeed, true);
			sprPlayer.add("sleep", [4], 0, false);
			
			graphic = sprPlayer;
			sprPlayer.play("stand");
			
			// Hit box
			sprPlayer.originX = 0;
			sprPlayer.originY = sprPlayer.height;
			sprPlayer.x = 0;
			sprPlayer.y = -sprPlayer.originY;	
			
			setHitbox(sprPlayer.width, sprPlayer.height, sprPlayer.originX, sprPlayer.originY);				
			
			// Location
			x = 50;
			y = Ground.y;
			
			// Input
			Input.define("X", Key.SPACE);
		}
		
		override public function added():void 
		{
			Player.startedWalking = false;
			Player.walking = false;
			Player.sleeping = false;			
			addTween(zzzAlarm);	
			zzzAlarm.start();
		}
		
		override public function update():void 
		{
			super.update();
			if (Player.walking && !sndWalking.playing)
			{
				sndWalking.loop(0.5);
			}
			
			if (Input.check("X") || Input.mouseDown)
			//if (true) 
			{
				walking = true;
				sleeping = false;
				sprPlayer.play("walk");
				if (!startedWalking) {
					startedWalking = true;
				}
			}
			else {
				walking = false;
			}
			
			
			if (!walking && (FP.world as MyWorld).time == 'night')
			{
				sleeping = true;				
			}
			
			if (sleeping)
			{
				sprPlayer.play("sleep");
			}
			else if (!walking)
			{
				sprPlayer.play("stand");
			}
			
			if (Input.released("X"))
			{
				sndWalking.stop();
				//var playerDying:PlayerDying = new PlayerDying;
				//FP.world.add(playerDying);
				//playerDying.x = x;
				//playerDying.y = y;
				//FP.world.remove(this);
			}
		}
		
		public function releaseZZZ():void 
		{
			//var randX:Number = x + FP.choose( -1, 1) * FP.rand(5);
			if (sleeping) 
			{
				FP.world.add(new Z(x + 6, y - 19));
			}
			zzzAlarm.reset(DEFAULT_ZZZ_INTERVAL);
		}		
	}
}