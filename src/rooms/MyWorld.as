package rooms
{
	import flash.net.LocalConnection;
	import game.*;
	import game.beach.Beach;
	import game.fjords.Fjords;
	import game.jungle.Jungle;
	import game.plains.Plains;
	import game.redwoods.Redwood;
	import game.redwoods.Redwoods;
	import game.snow.Snow;
	import net.flashpunk.Entity;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import game.forest.Forest;
	import game.desert.Desert;
	import game.Global;
	import flash.media.SoundMixer;
	import game.beach.Castle;
	import game.desert.Pyramids;
	import game.forest.GiantPine;
	import game.plains.FlowerTree;
	import game.snow.SnowMan;
	
	public class MyWorld extends World
	{
		/**
		 * How often to consider changing locations, also determined by
		 * how long we've been in a location.
		 */
		public const CHANGE_LOCATION_TIME:Number = 4;
		
		/**
		 * Norway stuff: spend a certain amount of time in each of these "countries"
		 * on the way to Norway, which dictates possible locations.
		 * Countries = 'california' ; 'mexico' ; 'oregon' ; 'usa' ; 'norway'
		 * 
		 * TODO: should maybe make "time in country" depend on number of location changes, rather than timePassed.
		 */		
		public var timePassed:Number = 0;	// Time since game start.
		public var country:String = 'california';
		public const TIME_IN_CALIFORNIA:Number = 20;	// 60 + Math.floor(Math.random() * 60)
		public const TIME_IN_MEXICO:Number = 20;
		public const TIME_IN_OREGON:Number = 20;
		public const TIME_IN_USA:Number = 20;
		
		/**
		 * Used to move objects slower than one pixel per frame
		 */
		public static var oddFrame:int = 1;
		public static var thirdFrame:int = 1;
		public static var fourthFrame:int = 1;
		public static var forceClouds:Boolean = false;
		
		/**
		 * Location
		 */
		public var location:Location;
		public var lastLocation:Location;
		public var nextLocation:Location;
		public var changeLocationAlarm:MyAlarm;
		
		public var soundController:SoundController;
		
		/**
		 * 'day', 'night', or 'sunset'
		 */
		public var time:String;
		
		/**
		 * Ground
		 */
		public static var ground:Ground;
		public static var oldGround:Ground;
		
		/**
		 * Title text
		 */
		public var titleTextAlarm:Alarm = new Alarm(3, showTitle);
		
		/**
		 * Size of the room (so it knows where to keep the player + camera in).
		 */
		public var width:uint;
		public var height:uint;
		
		public function MyWorld()      
		{
			// World size
			width = 300;
			height = 200;		
		
			// Set location
			location = FP.choose(new Fjords); // FP.choose(new Forest, new Desert, new Plains, new Snow, new Beach, new Redwoods);
			//location = new Jungle;
			add(location);
			changeLocationAlarm = new MyAlarm(CHANGE_LOCATION_TIME, changeLocationChance);
			addTween(changeLocationAlarm);
			changeLocationAlarm.start();
			
			// Sound controller
			add(soundController = new SoundController(location));			
			
			// Ground and sky
			add(ground = new Ground(location));
			ground.x = -ground.image.width/2;
			add(new Sky);
			
			// Mountain controller
			add(new MountainController);
			
			// Night-day cycle
			add(new Day(this, false));
			
			
			// Player and baby. (Baby added from Player class.)
			add(Global.player = new Player);
			
			// Interaction checker.
			if (Global.exhibition_setting) 
			{
				add(new InteractionChecker);
				InteractionChecker.timePassed = 0;
			}
			
			// Starting text
			addTween(titleTextAlarm);
			titleTextAlarm.start();
			//add(new textPress);
			
			// Start of game changes
			location.gameStart(this);
			location.creationTime = 2;
			location.creationTimeAlarm.reset(0.1);
			
			//FP.console.watch(timePassed);
		}
		
		/**
		 * Update the room.
		 */
		override public function update():void 
		{
			
			if (Global.testing) 
			{
				if (Input.pressed(Key.R)) 
				{
					restart();
				}

				// Testing
				if (Input.pressed(Key.C))
				{
					trace('c presesd');
					this.changeLocation();
				}
				else if (Input.pressed(Key.N))
				{
					trace('n presesd');
					advanceTime();
				}			
			}
			
			// Update entities
			super.update();
			
			// Update time passed.
			timePassed += FP.elapsed;
			//FP.console.log("timePassed:" + timePassed);
			//FP.console.log("country: " + country + " | timePassed: " + timePassed);	
			//FP.console.log("baby state: " + Global.player.baby.state);
			
			// Flip oddFrame every frame
			oddFrame *= -1;
			
			// Update thirdFrame
			if (thirdFrame == 3)
			{
				thirdFrame = 1;
			}
			else 
			{
				thirdFrame += 1;
			}
			
			// Update fourthFrame
			if (fourthFrame == 4)
			{
				fourthFrame = 1;
			}
			else 
			{
				fourthFrame += 1;
			}
		}		
		
		/**
		 * Change location now.
		 */
		public function changeLocation():void
		{
			return;
			trace('change location');
			
			// Check change country
			switch (country)
			{
				case 'california':
					if (timePassed > TIME_IN_CALIFORNIA) 
					{
						trace('change country to mexico');
						country = 'mexico';
					}
					else 
					{
						trace('change country no');
					}
					break;
				case 'mexico':
					if (timePassed > TIME_IN_CALIFORNIA + TIME_IN_MEXICO) 
					{
						trace('change country to oregon');
						country = 'oregon';
					}
					else 
					{
						trace('change country no');
					}					
					break;
				case 'oregon':
					if (timePassed > TIME_IN_CALIFORNIA + TIME_IN_MEXICO + TIME_IN_OREGON) 
					{
						trace('change country usa');
						country = 'usa';
					}
					else 
					{
						trace('change country no');
					}					
					break;
				case 'usa':
					if (timePassed > TIME_IN_CALIFORNIA + TIME_IN_MEXICO + TIME_IN_OREGON + TIME_IN_USA) 
					{
						trace('change country norway');
						country = 'norway';
					}		
					else 
					{
						trace('change country no');
					}					
					break;	
				default:
					country = 'norway'
					break;
			}
			
			//trace('Changing location');
			var newLocation:Location;
			do 
			{
				switch (country)
				{
					case 'california':
						newLocation = FP.choose(new Redwoods);
						break;
					case 'mexico':
						Global.player.baby.age = Baby.AGE_SMALL_CHILD;	// Baby grows.
						newLocation = FP.choose(new Desert);
						break;
					case 'oregon':
						Global.player.baby.age = Baby.AGE_LARGE_CHILD;	// Baby grows.
						newLocation = FP.choose(new Beach);
						break;
					case 'usa':
						newLocation = FP.choose(new Plains);
						break;
					case 'norway':
					default:
						newLocation = FP.choose(new Fjords);
						break;
				}
				
				//newLocation = FP.choose(new Forest, new Beach);
			} 
			while (newLocation.type == this.location.type);
			soundController.changeLocation(newLocation);
			remove(location);
			add(location = newLocation);
			oldGround = ground;
			add(ground = new Ground(location));			
			//trace('new location: ' + location);
		}
		
		/**
		 * Chance of changing location, or changing the location slope.
		 */
		public function changeLocationChance():void
		{
			//trace('change location chance');
			//trace('Slope: ' + location.creationTimeSlope);
			changeLocationAlarm.reset(CHANGE_LOCATION_TIME);
			switch (location.creationTimeSlope)
			{
				case 1:
					if (location.creationTime < (location.minCreationTime * 2))
					{
						if (FP.random > 0.6)
						{
							//trace('Changing slope from 1 to 0');
							location.creationTimeSlope = 0;
						}
					}
					break;
				case 0:
					if (FP.random > 0.6)
					{
						//trace('Changing slope from 0 to -1');
						location.creationTimeSlope = -1;
					}
					break;
				case -1:
					if (location.creationTime > (location.maxCreationTime * 0.75))
					{
						if (FP.random > 0.6)
						{
							changeLocation();
						}		
					}
					break;
			}
		}
		
		public function advanceTime():void
		{
			switch (time)
			{
				case 'day':
					add(new Sunset);
					break;
				case 'sunset':
					add(new Night);
					break;
				case 'night':
					add(new Day(this));
					break;
			}
		}
		
		public function showTitle():void
		{
			if (!Player.startedWalking) {
				add(new textPress);
			}
		}
		
		public function restart():void
		{
			// Stop all sounds. See https://forums.adobe.com/thread/860720
			Castle.seen = false;
			Pyramids.seen = false;
			GiantPine.seen = false;
			FlowerTree.seen = false;
			SnowMan.seen = false;
			SoundMixer.stopAll();
			Player.startedWalking = false;
			FP.world = new MyWorld;
		}
	}
}
 