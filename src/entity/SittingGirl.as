package entity 
{
    import org.flixel.FlxSprite;
	/**
     * ...
     * @author seagaia

     */
import org.flixel.plugin.photonstorm.FlxBitmapFont;
    public class SittingGirl extends FlxSprite
    {
        
        [Embed (source = "../../img/sittinggirl.png")] public var SittingGirl_Sprite:Class;
        public var text:FlxBitmapFont = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
        public function SittingGirl(_x:int,_y:int) 
        {
            super(_x, _y);
            loadGraphic(SittingGirl_Sprite, true, false, 40, 80);
            text.setText(" ", true, 0, 0, "left", true);
            addAnimation("Sit", [0, 0, 0, 0, 0, 0, 1, 0, 2], 5, true);
            play("Sit");
        }
        
        override public function update():void {
            text.x = x - 100;
            text.y = y + 90;
            super.update();
        }
    }

}