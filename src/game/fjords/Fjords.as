package game.fjords 
{

	import game.*;
	import game.fjords.*;	
	import net.flashpunk.FP;
	import game.Player;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.World;
	import net.flashpunk.Sfx;
	import rooms.MyWorld;
	
	public class Fjords extends Location
	{		
		public var creationNumber:Number;
		public var ocean:Ocean;
		
		/**
		 * Sound
		 */
		[Embed(source='../../../assets/sounds.swf', symbol='waves_ambient.wav')] private const DAY_SOUND:Class;
		[Embed(source='../../../assets/sounds.swf', symbol='waves_ambient.wav')] private const NIGHT_SOUND:Class;
		
		[Embed(source='../../../assets/sounds.swf', symbol='wind_burst.wav')] private const SND_WIND:Class;
		public var sndWind:Sfx = new Sfx(SND_WIND);				
		
		[Embed(source='../../../assets/sounds.swf', symbol='gulls_01.wav')] private const SND_GULLS01:Class;
		public var sndGulls01:Sfx = new Sfx(SND_GULLS01);	
		[Embed(source='../../../assets/sounds.swf', symbol='gulls_02.wav')] private const SND_GULLS02:Class;
		public var sndGulls02:Sfx = new Sfx(SND_GULLS02);	
		[Embed(source='../../../assets/sounds.swf', symbol='gulls_03.wav')] private const SND_GULLS03:Class;
		public var sndGulls03:Sfx = new Sfx(SND_GULLS03);		
		public var sndGullsRandom:Sfx = FP.choose(new Sfx(SND_GULLS01), new Sfx(SND_GULLS02), new Sfx(SND_GULLS03));
				
		
		public function Fjords() 
		{
			super(DAY_SOUND, NIGHT_SOUND);
			type = 'fjords';
			ocean = new Ocean;
		}
		
		override public function added():void
		{
			FP.world.add(ocean);
		}
		
		override public function update():void
		{
			super.update();
		}
		
		/**
		 * Controls item creation for this location.
		 */		
		override public function createItem():void
		{
			super.createItem();
			
			creationNumber = FP.random;	
			
			// Mid distance
			if (FP.random > 0.2 && Player.walking)
			{
				if (creationNumber < 0.01)
				{
					FP.world.add(new River);
				}
				else if (creationNumber < 0.05)
				{
					FP.world.add(new PinetreeSideways);
				}
				else if (creationNumber < 1)
				{
					FP.world.add(new Pinetree);
				}
			}
			
			// Sounds
			if (FP.random > 0.4)
			{
				var pan:Number = FP.choose( -1, 1) * FP.random;
				var vol:Number = 0.3 + 0.7 * FP.random;
				// Night sounds
				if ((FP.world as MyWorld).time == 'night')
				{
					if (creationNumber < 0.05 && !sndGullsRandom.playing)
					{
						sndGullsRandom = FP.choose(sndGulls01, sndGulls02, sndGulls03);
						sndGullsRandom.play(vol, pan);
					}					
					else if (creationNumber < 0.15 && !sndWind.playing)
					{
						sndWind.play(vol, pan);
					}		
				}
				// Day sounds
				else
				{
					if (creationNumber < 0.1 && !sndWind.playing)
					{
						sndWind.play(vol, pan);
					}						
					else if (creationNumber < 0.6 && !sndGullsRandom.playing)
					{
						sndGullsRandom = FP.choose(sndGulls01, sndGulls02, sndGulls03);
						sndGullsRandom.play(vol, pan);
					}					
				}
			}	
			
		}	
		
		override public function removed():void
		{
			ocean.fadeOut();		
		}

		/**
		 * Stuff to set up at the beginning of the game.
		 * @param	world	Current world.
		 */
		override public function gameStart(world:World):void
		{
			super.gameStartItem(world, new Pinetree);	
		}
		
	}

}