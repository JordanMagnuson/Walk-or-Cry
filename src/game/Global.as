package game 
{
	/**
	 * ...
	 * @author ...
	 */
	public class Global 
	{
		public static var testing:Boolean = true;	// Debug setting.		
		public static var exhibition_setting:Boolean = false;	// Are we showing the game at an exhibition? (need auto restart with interaction checker, etc.)
		public static var baby_should_make_sounds:Boolean = false;
		
		public static var player:Player;
		public static var babyType:String = "stroller";
		
		public static var worldStopped:Boolean = false;
		public static var timeInFjords:Number = 0;
	}

}