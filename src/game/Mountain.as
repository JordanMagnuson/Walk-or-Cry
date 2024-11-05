package game
{
	import game.Item;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import rooms.MyWorld;
	import game.fjords.Ocean;
	
	public class Mountain extends Item
	{	
		/**
		 * Graphics
		 */
		[Embed(source = '../../assets/forest/mountain01.png')] private const FOREST_MOUNTAIN01:Class;			
		[Embed(source = '../../assets/forest/mountain02.png')] private const FOREST_MOUNTAIN02:Class;		
		[Embed(source = '../../assets/desert/mountain01.png')] private const DESERT_MOUNTAIN01:Class;			
		[Embed(source = '../../assets/desert/mountain02.png')] private const DESERT_MOUNTAIN02:Class;				
		[Embed(source = '../../assets/snow/mountain01.png')] private const SNOW_MOUNTAIN01:Class;			
		[Embed(source = '../../assets/snow/mountain02.png')] private const SNOW_MOUNTAIN02:Class;		
		[Embed(source = '../../assets/plains/mountain01.png')] private const PLAINS_MOUNTAIN01:Class;			
		[Embed(source = '../../assets/plains/mountain02.png')] private const PLAINS_MOUNTAIN02:Class;	
		[Embed(source = '../../assets/beach/mountain01.png')] private const BEACH_MOUNTAIN01:Class;			
		[Embed(source = '../../assets/beach/mountain02.png')] private const BEACH_MOUNTAIN02:Class;	
		[Embed(source = "../../assets/fjords/mountain01.png")] private const FJORDS_MOUNTAIN01:Class;
		[Embed(source = "../../assets/fjords/mountain02.png")] private const FJORDS_MOUNTAIN02:Class;
		[Embed(source = "../../assets/fjords/large_mountain01.png")] private const FJORDS_LARGE_MOUNTAIN01:Class;
		[Embed(source = "../../assets/fjords/large_mountain02.png")] private const FJORDS_LARGE_MOUNTAIN02:Class;		
		
		public function Mountain() 
		{
			// Determine image based on location
			switch ((FP.world as MyWorld).location.type)
			{
				case 'forest':
					rawSprite = chooseSprite(new Array(FOREST_MOUNTAIN01, FOREST_MOUNTAIN02));	
					break;
				case 'desert':
					rawSprite = chooseSprite(new Array(DESERT_MOUNTAIN01, DESERT_MOUNTAIN02));	
					break;		
				case 'snow':
					rawSprite = chooseSprite(new Array(SNOW_MOUNTAIN01, SNOW_MOUNTAIN02));	
					break;	
				case 'plains':
					rawSprite = chooseSprite(new Array(PLAINS_MOUNTAIN01, PLAINS_MOUNTAIN02));	
					break;		
				case 'beach':
					rawSprite = chooseSprite(new Array(BEACH_MOUNTAIN01, BEACH_MOUNTAIN02));	
					break;	
				case 'fjords':
					rawSprite = chooseSprite(new Array(FJORDS_MOUNTAIN01, FJORDS_MOUNTAIN02, FJORDS_LARGE_MOUNTAIN01, FJORDS_LARGE_MOUNTAIN02));	
					break;										
				default:
					rawSprite = chooseSprite(new Array(FOREST_MOUNTAIN01, FOREST_MOUNTAIN02));	
					break;									
			}			
			super(rawSprite, 'far', true);
			type = 'mountain';
			
			if ((FP.world as MyWorld).location.type == 'fjords') 
			{
				y = Ocean.Y_TOP;
				type = 'elevated_mountain';
				if (rawSprite == FJORDS_LARGE_MOUNTAIN01 || rawSprite == FJORDS_LARGE_MOUNTAIN01) {
					if (FP.random < 0.5) {
						layer = 200;	// Random chance that large mountains are set to cloud layer (to give some epic quality).
					}					
				}
				layer += 10;			// Elevated mountains should be more distant (appear behind) other mountains (and/or clouds)
			}
		}
		
		override public function update():void 
		{
			super.update();
		}
	}
}