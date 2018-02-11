package game
{
	import flash.filesystem.File;
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.sound.SfxFader;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import rooms.MyWorld;
	
	public class Baby extends Entity
	{
		public static const DEFAULT_CRY_INTERVAL:Number = 7;
		public static const DEFAULT_COO_INTERVAL:Number = 1;
		
		public var isCrying:Boolean = false;
		public var cryInterval:Number = DEFAULT_CRY_INTERVAL;
		public var cryAlarm:Alarm = new Alarm(DEFAULT_CRY_INTERVAL, cry);		
		public var cooAlarm:Alarm = new Alarm(DEFAULT_COO_INTERVAL, coo);
		
		/**
		 * Sound
		 */		
		
		// Crying
		public var cryingSoundArray:Array = new Array();
		[Embed(source = "../../assets/baby/crying_01.mp3")] private const SND_CRYING_01:Class;
		[Embed(source = "../../assets/baby/crying_02.mp3")] private const SND_CRYING_02:Class;
		[Embed(source = "../../assets/baby/crying_03.mp3")] private const SND_CRYING_03:Class;
		[Embed(source = "../../assets/baby/crying_04.mp3")] private const SND_CRYING_04:Class;
		[Embed(source = "../../assets/baby/crying_05.mp3")] private const SND_CRYING_05:Class;
		[Embed(source = "../../assets/baby/crying_06.mp3")] private const SND_CRYING_06:Class;
		[Embed(source = "../../assets/baby/crying_07.mp3")] private const SND_CRYING_07:Class;
		[Embed(source = "../../assets/baby/crying_08.mp3")] private const SND_CRYING_08:Class;
		[Embed(source = "../../assets/baby/crying_09.mp3")] private const SND_CRYING_09:Class;
		[Embed(source = "../../assets/baby/crying_10.mp3")] private const SND_CRYING_10:Class;
		[Embed(source = "../../assets/baby/crying_11.mp3")] private const SND_CRYING_11:Class;
		[Embed(source = "../../assets/baby/crying_12.mp3")] private const SND_CRYING_12:Class;
		[Embed(source = "../../assets/baby/crying_13.mp3")] private const SND_CRYING_13:Class;
		[Embed(source = "../../assets/baby/crying_14.mp3")] private const SND_CRYING_14:Class;
		[Embed(source = "../../assets/baby/crying_15.mp3")] private const SND_CRYING_15:Class;
		[Embed(source = "../../assets/baby/crying_16.mp3")] private const SND_CRYING_16:Class;
		[Embed(source = "../../assets/baby/crying_17.mp3")] private const SND_CRYING_17:Class;
		
		// Short sounds.
		public var babySoundArray:Array = new Array();
		[Embed(source = "../../assets/baby/short_sound_01.mp3")] private const SND_BABY_01:Class;
		[Embed(source = "../../assets/baby/short_sound_02.mp3")] private const SND_BABY_02:Class;
		[Embed(source = "../../assets/baby/short_sound_03.mp3")] private const SND_BABY_03:Class;
		[Embed(source = "../../assets/baby/short_sound_04.mp3")] private const SND_BABY_04:Class;
		[Embed(source = "../../assets/baby/short_sound_05.mp3")] private const SND_BABY_05:Class;
		[Embed(source = "../../assets/baby/short_sound_06.mp3")] private const SND_BABY_06:Class;
		[Embed(source = "../../assets/baby/short_sound_07.mp3")] private const SND_BABY_07:Class;
		[Embed(source = "../../assets/baby/short_sound_08.mp3")] private const SND_BABY_08:Class;
		[Embed(source = "../../assets/baby/short_sound_09.mp3")] private const SND_BABY_09:Class;
		[Embed(source = "../../assets/baby/short_sound_12.mp3")] private const SND_BABY_10:Class;
		[Embed(source = "../../assets/baby/short_sound_11.mp3")] private const SND_BABY_11:Class;
		[Embed(source = "../../assets/baby/short_sound_12.mp3")] private const SND_BABY_12:Class;
		[Embed(source = "../../assets/baby/short_sound_13.mp3")] private const SND_BABY_13:Class;
		[Embed(source = "../../assets/baby/short_sound_14.mp3")] private const SND_BABY_14:Class;
		[Embed(source = "../../assets/baby/short_sound_15.mp3")] private const SND_BABY_15:Class;
		[Embed(source = "../../assets/baby/short_sound_16.mp3")] private const SND_BABY_16:Class;
		[Embed(source = "../../assets/baby/short_sound_17.mp3")] private const SND_BABY_17:Class;
		[Embed(source = "../../assets/baby/short_sound_18.mp3")] private const SND_BABY_18:Class;		
		[Embed(source = "../../assets/baby/short_sound_19.mp3")] private const SND_BABY_19:Class;
		[Embed(source = "../../assets/baby/short_sound_20.mp3")] private const SND_BABY_20:Class;
		[Embed(source = "../../assets/baby/short_sound_21.mp3")] private const SND_BABY_21:Class;
		[Embed(source = "../../assets/baby/short_sound_22.mp3")] private const SND_BABY_22:Class;
		[Embed(source = "../../assets/baby/short_sound_23.mp3")] private const SND_BABY_23:Class;
		[Embed(source = "../../assets/baby/short_sound_24.mp3")] private const SND_BABY_24:Class;		
		
		public function Baby() 
		{
			// Build crying sound array.
			for (var i:int = 1; i <= 17; i++) 
			{
				if (i < 10) 
				{
					cryingSoundArray[i-1] = new Sfx(this["SND_CRYING_0" + i]);
				}
				else 
				{
					cryingSoundArray[i-1] = new Sfx(this["SND_CRYING_" + i]);
				}
			}	
			// Build baby sound array.
			for (var j:int = 1; j <= 24; j++) 
			{
				if (j < 10) 
				{
					babySoundArray[j-1] = new Sfx(this["SND_BABY_0" + j]);
				}
				else 
				{
					babySoundArray[j-1] = new Sfx(this["SND_BABY_" + j]);
				}
			}
			
			trace('baby created');
			addTween(cryAlarm);
			addTween(cooAlarm);
			cooAlarm.start();
			//startCryingAlarm.active = false;		
		}
		
		override public function update():void 
		{
			super.update();
			//trace('sndCryingHard.volume:' + sndCryingHard.volume);
			if ((FP.world as MyWorld).time != 'night' && !Player.walking && !isCrying) 
			{
				//trace('should start crying');
				startCrying();
			}
			
			//if (Player.walking && !babySoundPlaying()) {
				//trace('should play baby sound');
				//playRandomBabySound(0.5);
			//}
		}
		
		public function startCrying(vol:Number = 1):void
		{
			trace('startCrying');
			isCrying = true;
			cryAlarm.start();
		}
		
		public function coo():void {
			trace('coo (maybe)');
			if ((FP.world as MyWorld).time != 'night' && !isCrying)
			{
				if (FP.random < 0.25 && !babySoundPlaying()) {
					trace('yes play coo sound');
					var sound:Sfx = playRandomBabySound();
				}
				
			}			
			cooAlarm.reset(DEFAULT_COO_INTERVAL);
		}
		
		public function cry():void {
			trace('cry');
			if (isCrying)
			{
				if (!Player.walking)
				{
					// Not walking: cry more.
					cryInterval -= 0.5;
					if (cryInterval < 0.5) {
						cryInterval = 0.5;
					}
				}
				else 
				{
					// Walking: cry less.
					cryInterval += 1;
					if (cryInterval > DEFAULT_CRY_INTERVAL/2) {
						stopCrying();
						return;
					}
				}
				var sound:Sfx = playRandomCryingSound();
				if (cryInterval < sound.length) {
					cryAlarm.reset(sound.length);
				}
				else {
					cryAlarm.reset(cryInterval);
				}			
				trace('cryInterval: ' + cryInterval);
			}
		}
		
		public function stopCrying():void 
		{
			trace('stopCrying');
			isCrying = false;
			cryInterval = DEFAULT_CRY_INTERVAL;
		}		
		
		public function cryingSoundPlaying():Boolean
		{
			for (var i:String in cryingSoundArray) 
			{ 
				if (cryingSoundArray[i].playing) 
				{
					return true;
				}
			}
 			return false;			
		}
		
		public function babySoundPlaying():Boolean 
		{
			for (var i:String in babySoundArray) 
			{ 
				if (babySoundArray[i].playing) 
				{
					return true;
				}
			}
 			return false;
		}
		
		public function playRandomCryingSound(vol:Number = 1):Sfx 
		{
			//trace('crying sound array length: ' + cryingSoundArray.length);
			var idx:int = Math.floor(Math.random() * cryingSoundArray.length);
			trace(idx);
			var sound:Sfx = cryingSoundArray[idx];		
			sound.play(vol);
			return sound;
		}		
		
		public function playRandomBabySound(vol:Number = 1):Sfx 
		{
			//trace('baby sound array length: ' + babySoundArray.length);
			var idx:int = Math.floor(Math.random() * babySoundArray.length);
			trace(idx);
			var sound:Sfx = babySoundArray[idx];		
			sound.play(vol);
			return sound;
		}
		
		//public static function checkFileExists(input:String):Boolean {
			//var testing_file:File = File.applicationStorageDirectory.resolvePath(input);
			//
			//if (testing_file.exists)
				//return true;
			//else
				//return false;
		//}		
	}
}