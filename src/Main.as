package  
{
	import net.flashpunk.*;
	import rooms.*;
	import game.*;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	
	public class Main extends Engine
	{
		public function Main() 
		{
			// Initiate the game with a 300x200 screen.
			super(300, 200, 60, false);
			
			// Scale the screen.
			FP.screen.scale = 3;	// 5 for 1920x1080
			FP.screen.color = Colors.WHITE;
			
			// Center the screen in Flash Player (this is only relevant when using stand alone flash player to play the game in fullscreen mode). 
			FP.screen.x = (900 - FP.width * FP.screen.scale) / 2;
			FP.screen.y = (600 - FP.height * FP.screen.scale) / 2;
			
			//FP.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			// Console for debugging
			//FP.console.enable();					
			
			FP.world = new MyWorld;
		}
		
		override public function init():void
		{
			// Full screen
			FP.stage.scaleMode = StageScaleMode.SHOW_ALL;
			FP.stage.fullScreenSourceRect = new Rectangle(0, 0, 1920, 1080);
			FP.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;				
			super.init();
		}
	}
}