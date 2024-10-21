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
		public static var lastPressedKey:int = 0;
		public static var lastPressedAgo:Number = 0;
		public static var timeSinceWalking:Number = 0;		
		
		public static const DEFAULT_ZZZ_INTERVAL:Number = 1;
		public var zzzAlarm:Alarm = new Alarm(DEFAULT_ZZZ_INTERVAL, releaseZZZ);
		
		/**
		 * Player graphic
		 */
		[Embed(source="../../assets/stroller.png")] private const STROLLER:Class;
		public var sprStroller:Spritemap = new Spritemap(STROLLER, 48, 17);
		
		// Forntpack sprite alternative to stroller for youngest baby.
		//[Embed(source='../../assets/walking_frontpack_spritesheet.png')] private const FRONTPACK:Class;
		//public var sprFrontPack:Spritemap = new Spritemap(FRONTPACK, 10, 17);	
		
		[Embed(source="../../assets/holding_hands_with_small_child.png")] private const HOLDING_HANDS_WITH_SMALL_CHILD:Class;
		public var sprHoldingHandsWithSmallChild:Spritemap = new Spritemap(HOLDING_HANDS_WITH_SMALL_CHILD, 48, 17);	
		
		[Embed(source = "../../assets/holding_small_child.png")] private const HOLDING_SMALL_CHILD:Class;
		public var sprHoldingSmallChild:Spritemap = new Spritemap(HOLDING_SMALL_CHILD, 48, 17);	
		
		public var sprPlayer:Spritemap;
		
		/**
		 * Sound
		 */
		[Embed(source='../../assets/sounds.swf', symbol='walking.wav')] private const SND_WALKING:Class;
		public var sndWalking:Sfx = new Sfx(SND_WALKING);			
		
		/**
		 * Baby
		 */
		public var baby:Baby;
		
		public function Player() 
		{
			// Set up spritesheets and animations.
			animSpeed = Player.SPEED / 10;			
			// STROLLER
			sprStroller.add("stand", [0], 20, false);
			sprStroller.add("walk", [0, 1, 2, 3], animSpeed, true);
			sprStroller.add("sleep", [4], 0, false);
			sprStroller.originX = 16;
			sprStroller.originY = sprStroller.height;
			sprStroller.x = -16;
			sprStroller.y = -sprStroller.originY;				
			// HOLDING_HANDS_WITH_SMALL_CHILD
			sprHoldingHandsWithSmallChild.add("stand", [0], 20, false);
			sprHoldingHandsWithSmallChild.add("walk", [0, 1, 2, 3], animSpeed, true);
			sprHoldingHandsWithSmallChild.add("sleep", [4], 0, false);		
			sprHoldingHandsWithSmallChild.originX = 16;
			sprHoldingHandsWithSmallChild.originY = sprHoldingHandsWithSmallChild.height;
			sprHoldingHandsWithSmallChild.x = -16;
			sprHoldingHandsWithSmallChild.y = -sprHoldingHandsWithSmallChild.originY;				
			// HOLDING_SMALL_CHILD
			sprHoldingSmallChild.add("stand", [0], 20, false);
			sprHoldingSmallChild.add("walk", [0, 1, 2, 3], animSpeed, true);
			sprHoldingSmallChild.add("sleep", [4], 0, false);			
			sprHoldingSmallChild.originX = 16;
			sprHoldingSmallChild.originY = sprHoldingSmallChild.height;
			sprHoldingSmallChild.x = -16;
			sprHoldingSmallChild.y = -sprHoldingSmallChild.originY;				
			
			// Location
			x = 50;
			y = Ground.y;
			
			// Input
			Input.define("X", Key.SPACE);
			Input.define("A", Key.A);
			Input.define("S", Key.S);
			Input.define("D", Key.D);
		}
		
		override public function added():void 
		{
			Player.startedWalking = false;
			Player.walking = false;
			Player.sleeping = false;			
			addTween(zzzAlarm);	
			zzzAlarm.start();
			
			// Add the baby here, so we can reference it easily from within the Player class.
			FP.world.add(baby = new Baby);
			
			// Set starting sprite.
			updateSprite();
			sprPlayer.play("stand");			
		}
		
		override public function update():void 
		{
			super.update();
			
			// Walking sound.
			if (Player.walking && !sndWalking.playing)
			{
				sndWalking.loop(0.5);
			}
			else if (!Player.walking && sndWalking.playing)
			{
				sndWalking.stop();
			}
			
			// Force player to press alternate keys successively to "walk"
			if (Input.pressed("A") && lastPressedKey != Key.A) {
				lastPressedKey = Key.A;
				lastPressedAgo = 0;
			}
			else if (Input.pressed("S") && lastPressedKey != Key.S) {
				lastPressedKey = Key.S;
				lastPressedAgo = 0;
			}
			else if (Input.pressed("D") && lastPressedKey != Key.D) {
				lastPressedKey = Key.D;
				lastPressedAgo = 0;
			}			
			else {
				lastPressedAgo += FP.elapsed;
			}
			
			// Walking?
			if (!Global.testing) {
				// Regular use case - not testing.
				if (lastPressedAgo == 0) 
				{
					//trace(Input.keyString.substr(-1,1));
					walking = true;
					sleeping = false;
					//sprPlayer.play("walk");
					if (!startedWalking) {
						startedWalking = true;
					}
				}
				else if (lastPressedAgo > 0.6) {
					walking = false;
				}
			}
			else {
				// Testing / debugging: press space to toggle walking / not walking.
				if (Input.pressed(Key.SPACE)) 
				{
					trace('pressed spacebar');
					if (!walking) 
					{
						walking = true;
						sleeping = false;
						//sprPlayer.play("walk");
						if (!startedWalking) {
							startedWalking = true;
						}
					}
					else 
					{
						walking = false;
					}					
				}
			}
			
			// Keep track of how long we hae been stopped.
			// (Baby should only start crying if we've been stopped for a while)
			if (walking) {
				timeSinceWalking = 0;
			}
			else {
				timeSinceWalking += FP.elapsed;
			}			
			
			if (!walking && (FP.world as MyWorld).time == 'night' && startedWalking)
			{
				sleeping = true;				
			}
			
			// Update animation depending on state.
			if (sleeping)
			{
				sprPlayer.play("sleep");
			}
			else if (walking)
			{
				sprPlayer.play("walk");
			}
			else {
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
			
			// Update sprite?
			updateSprite();
		}
		
		public function updateSprite():void 
		{
			//trace('Player.updateSprite()');
			var oldSprite:Spritemap = sprPlayer;
			var newSprite:Spritemap;
			
			// Testing / Debugging.
			if (Global.testing) {
				if (Input.pressed(Key.DIGIT_1)) {
					newSprite = sprStroller;			
				}
				else if (Input.pressed(Key.DIGIT_2)) {
					newSprite = sprHoldingSmallChild;
				}
				else if (Input.pressed(Key.DIGIT_3)) {
					newSprite = sprHoldingHandsWithSmallChild;
				}				
			}
			
			switch (baby.age) {
				case Baby.AGE_BABY:
					newSprite = sprStroller;
					break;
				case Baby.AGE_SMALL_CHILD:
					// Hold the small child during sunset and night.
					if ((FP.world as MyWorld).time == 'day' && !sleeping)
					{
						newSprite = sprHoldingHandsWithSmallChild;
					}
					else 
					{
						newSprite = sprHoldingSmallChild;
					}
					break;
			}
			
			// Did sprite change?
			if (newSprite != oldSprite) 
			{
				trace('Player.updateSprite() - SPRITE CHANGED');
				sprPlayer = newSprite;
				graphic = sprPlayer;
				setHitbox(sprPlayer.width, sprPlayer.height, sprPlayer.originX, sprPlayer.originY);			
			}
		}
		
		public function releaseZZZ():void 
		{
			//var randX:Number = x + FP.choose( -1, 1) * FP.rand(5);
			if (sleeping) 
			{
				if (Global.babyType == "stroller") {
					FP.world.add(new Z(x + 5, y - 18));
				}
				else {
					FP.world.add(new Z(x + 6, y - 19));
				}
			}
			zzzAlarm.reset(DEFAULT_ZZZ_INTERVAL);
		}		
	}
}