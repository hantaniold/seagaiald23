package entity 
{
	/**
     * ...
     * @author seagaia

     */
    import flash.geom.Rectangle;
    import org.flixel.FlxSprite;
    public class Canvas extends FlxSprite
    {
        
        public function Canvas(_x:int,_y:int) 
        {
            super(_x, _y);
            makeGraphic(400, 400, 0xffffffff);
            
       }
       
       override public function update():void {
            if (Registry.keywatch.JP_ACTION_1) {
                for (var i:int = 0; i < width; i++) {
                    pixels.setPixel32(i, int(height * Math.random()), 0xff000000 + 0x00ff0000 * Math.random());
                    
                }
                dirty = true;
            }
            super.update();
       }
        
    }

}