package entity 
{
    import org.flixel.FlxSprite;
	/**
     * ...
     * @author seagaia

     */
    public class SittingGirl extends FlxSprite
    {
        
        [Embed (source = "../../img/sittinggirl.png")] public var SittingGirl_Sprite:Class;
        public function SittingGirl(_x:int,_y:int) 
        {
            super(_x, _y);
            loadGraphic(SittingGirl_Sprite, true, false, 40, 80);
            addAnimation("Sit", [0, 0, 0, 0, 0, 0, 1, 0, 2], 5, true);
            play("Sit");
        }
        
        override public function update():void {
            super.update();
        }
    }

}