package  
{
	import net.flashpunk.*;
	import rooms.*;
	import game.*;
	
	public class Main extends Engine
	{
		public function Main() 
		{
			// Initiate the game with a 300x200 screen.
			super(300, 200, 60, false);
			
			// Scale the screen.
			FP.screen.scale = 1;	// 5
			FP.screen.color = Colors.WHITE;
			
			// Center the screen in Flash Player (this is only relevant when using stand alone flash player to play the game in fullscreen mode). 
			FP.screen.x = (640 - FP.width * FP.screen.scale) / 2;
			FP.screen.y = (480 - FP.height * FP.screen.scale) / 2;
			
			// Console for debugging
			//FP.console.enable();					
			
			FP.world = new MyWorld;
		}
		
		override public function init():void
		{
			super.init();
		}
	}
}