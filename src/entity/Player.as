package entity 
{
	/**
     * ...
     * @author seagaia

     */
    import org.flixel.FlxSprite;
    public class Player extends FlxSprite
    {
        [Embed (source = "../../img/player.png")] public var Player_Sprite:Class;
        public var WALK_SPEED:int = 150;
        public function Player(_x:int, _y:int) 
        {
            super(_x, _y);
            loadGraphic(Player_Sprite, true, false, 40, 80);
            addAnimation("walk", [0, 1, 2, 3, 4], 6, true);
            addAnimation("still", [0], 1, true);
            play("still");
        }
        
        override public function update():void {
            if (Registry.keywatch.LEFT) {
                play("walk");
                scale.x = 1;
                velocity.x = -WALK_SPEED;
            } else if (Registry.keywatch.RIGHT) {
                play("walk");
                scale.x = -1;
                velocity.x = WALK_SPEED;
            } else {
                velocity.x = 0;
                play("still");
            }
        }
        
    }

}