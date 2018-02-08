package game
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.sound.SfxFader;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	public class Baby extends Entity
	{
		
		/**
		 * Sound
		 */		
		public var willCry:Boolean = false;
		public var startCryingAlarm:Alarm = new Alarm(3, startCrying);
		
		// Crying
		[Embed(source="../../assets/baby/crying_hard_01.mp3")] private const SND_CRYING_HARD:Class;
		public var sndCryingHard:Sfx = new Sfx(SND_CRYING_HARD);
		public var cryingFader:SfxFader = new SfxFader(sndCryingHard, stopCrying);
		
		// Short sounds.
		[Embed(source="../../assets/baby/short_sound_01.mp3")] private const SND_BABY_01:Class;
		public var sndBaby01:Sfx = new Sfx(SND_BABY_01);
		
		[Embed(source="../../assets/baby/short_sound_02.mp3")] private const SND_BABY_02:Class;
		public var sndBaby02:Sfx = new Sfx(SND_BABY_02);
		
		// Short sound array.
		public var babySoundArray:Array =  new Array(sndBaby01, sndBaby02);
		
		public function Baby() 
		{
			trace('baby created');
			addTween(cryingFader); 
			addTween(startCryingAlarm);
			//startCryingAlarm.active = false;
			sndCryingHard.loop(0);			
		}
		
		override public function update():void 
		{
			super.update();
			//trace('sndCryingHard.volume:' + sndCryingHard.volume);
			if (!Player.walking && sndCryingHard.volume == 0 && !startCryingAlarm.active) 
			{
				//trace(startCryingAlarm.remaining);
				trace('set start crying alarm');
				
				//startCryingAlarm.active = true;
				startCryingAlarm.start();
				willCry = true;
			} 
			
			if (Player.walking && sndCryingHard.volume > 0) 
			{
				trace('stop crying');
				stopCrying();
				//cryingFader.fadeTo(0, 3);
			} 
			
			if (Player.walking && !babySoundPlaying()) {
				trace('should play baby sound');
				playRandomBabySound(0.5);
			}
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
		
		public function playRandomBabySound(vol:Number = 1):void 
		{
			var idx:int=Math.floor(Math.random() * babySoundArray.length);
			var babySound:Sfx = babySoundArray[idx];		
			babySound.play(vol);

		}
		
		public function startCrying(vol:Number = 1):void
		{
			trace('startCrying');
			sndCryingHard.volume = 0.5;
			//startCryingAlarm.active = false;
			willCry = false;
		}
		
		public function stopCrying():void 
		{
			sndCryingHard.volume = 0;
			//sndCryingHard.stop();
		}
	}
}