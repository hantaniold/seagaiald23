package entity 
{
	/**
     * ...
     * @author seagaia

     */
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import org.flixel.FlxSprite;
    import org.flixel.FlxG;
    import flash.display.BitmapDataChannel;
    public class Canvas extends FlxSprite
    {
        public var LEFT:int = 12;
        public var RIGHT:int = 23;
        public var UP:int = 44;
        public var DOWN:int = 34;
        
        public var state:int = 0;
        public var S_NORMAL:int = 0;
        
        public var S_DRAW_HOR:int = 1;
        public var draw_hor_timer:Number = 0;
        public var draw_hor_interval:Number = 0.01;
        public var hor_alpha:Number = 1;
        public var horizontal_marker:FlxSprite;
        public var horizontal_marker_dir:int = RIGHT;
        
        public var S_DRAW_VERT:int = 2;
        public var draw_vert_timer:Number = 0;
        public var draw_vert_interval:Number = 0.01;
        public var vert_alpha:Number = 0;
        public var vertical_marker:FlxSprite;
        public var vertical_marker_dir:int = DOWN;
        
        public var base:FlxSprite;
        
        public function Canvas(size:Rectangle) 
        {
            super(size.x,size.y);
            makeGraphic(size.width, size.height, 0x88ffffff);
            
            
            base = new FlxSprite(x, y);
            base.makeGraphic(width, height, 0x88ffffff);
            
            horizontal_marker =  new FlxSprite(x, y + height);
            horizontal_marker.makeGraphic(3, 4, 0xffff0000);
            horizontal_marker.visible = false;
            
            vertical_marker = new FlxSprite(x, y);
            vertical_marker.makeGraphic(3, 3, 0xff00ff00);
            vertical_marker.visible = false;
            
            state = S_NORMAL;
            
       }
       
       override public function update():void {
            
            
            switch (state) {
                case S_DRAW_HOR:
                    draw_hor();
                    break;
                case S_DRAW_VERT:
                    draw_vert();
                    break;
            }
            
            super.update();
       }
       
       public function draw_hor():void {
            draw_hor_timer += FlxG.elapsed;
            if (draw_hor_timer > draw_hor_interval) {
                if (horizontal_marker_dir == RIGHT) {
                    horizontal_marker.x ++;
                    if (horizontal_marker.x > (x + width)) {
                        horizontal_marker_dir = LEFT;
                    }
                } else {
                    horizontal_marker.x --;
                    if (horizontal_marker.x < x) {
                        horizontal_marker_dir = RIGHT;
                    }
                }
                draw_hor_timer = 0;
            }
            if (Registry.keywatch.ACTION_1) {
                if (hor_alpha > 0) { 
                    hor_alpha -= 0.02;
                } else {
                    hor_alpha = 0;
                }
                for (var i:int = 0; i < height; i++) {
                    pixels.setPixel32(horizontal_marker.x - x, i, pixels.getPixel32(horizontal_marker.x - x, i) + 0x00ff0000 + int(hor_alpha * 255) * 0x01000000);
                    if (Math.random() < 0.25) {
                        pixels.setPixel32(horizontal_marker.x - x, i, 0x00000000);
                    }
                }
                dirty = true;
            } else {
                hor_alpha = 1;
            }
       }
       
       public function draw_vert():void {
            draw_vert_timer += FlxG.elapsed;
            if (draw_vert_timer > draw_vert_interval) {
                
                if (vertical_marker_dir == DOWN) {
                    vertical_marker.y ++;
                    if (vertical_marker.y > y + height) {
                        vertical_marker_dir = UP;
                    }
                } else {
                    vertical_marker.y --;
                    if (vertical_marker.y < y) {
                        vertical_marker_dir = DOWN;
                    }
                }
                draw_vert_timer = 0;
             }
            if (Registry.keywatch.ACTION_1)  {
                if (vert_alpha > 0) {
                    vert_alpha -= 0.02;
                } else {
                    vert_alpha = 0;
                }
                for (var i:int = 0; i < width; i++) {
                    pixels.setPixel32(i, vertical_marker.y - y, 0x0000ff00 + int(vert_alpha * 255) * 0x01000000);
                }
                dirty = true;
                
            } else {
                vert_alpha = 1;
            }
            
               
       }
        
    }

}