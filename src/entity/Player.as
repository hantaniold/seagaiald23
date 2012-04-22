package entity 
{
	/**
     * ...
     * @author seagaia

     */
    import org.flixel.FlxSprite;
    import org.flixel.FlxState;
    import org.flixel.plugin.photonstorm.FlxBitmapFont;
    public class Player extends FlxSprite
    {
        [Embed (source = "../../img/player.png")] public var Player_Sprite:Class;
        [Embed (source = "../../img/press_x.png")] public var Press_X_Sprite:Class;
        
        public var WALK_SPEED:int = 150;
        public var frozen:Boolean = false;
        public var text:FlxBitmapFont = new FlxBitmapFont(Registry.Font, 8, 14, Registry.fontString, 30, 0, 0, 0, 0);
        public var press_x:FlxSprite;
        public function Player(_x:int, _y:int) 
        {
            super(_x, _y);
            text.setText(" ", true, 0, 1, "left", true);
            loadGraphic(Player_Sprite, true, false, 40, 80);
            addAnimation("walk", [0, 1, 2, 3, 4,5,6,7], 8, true);
            addAnimation("stop", [2,1,0,7], 8, false);
            addAnimation("still", [7], 1, true);
            
            press_x = new FlxSprite(0, 0);
            press_x.loadGraphic(Press_X_Sprite, true, false, 18, 30);
            press_x.addAnimation("press", [3, 0, 1, 2], 5, true);
            press_x.play("press");
            press_x.visible = false;
            play("still");
            text.x = x - 80;
            text.y = y - 48;
            
        }
        
        override public function update():void {
        
            if (frozen) return;
            text.x = x - 80;
            text.y = y - 48;
            
            press_x.x = x - 98;
            press_x.y = y - 48;
            
            press_x.visible = false;
            if (Registry.keywatch.LEFT) {
                play("walk");
                scale.x = -1;
                velocity.x = -WALK_SPEED;
            } else if (Registry.keywatch.RIGHT) {
                play("walk");
                scale.x = 1;
                velocity.x = WALK_SPEED;
            } else if (Registry.keywatch.JR_LEFT) {
                
                velocity.x = 0;
                play("stop");
            } else if (Registry.keywatch.JR_RIGHT) {
                velocity.x = 0;
                play("stop");
                scale.x = 1;
            } else if (frame == 7) {
                velocity.x = 0;
                play("still");
            }
        }
        
    }

}