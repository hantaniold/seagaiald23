package entity 
{
	/**
     * ...
     * @author seagaia

     */
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.display.BlendMode;
    import org.flixel.FlxSprite;
    import org.flixel.FlxG;
    import flash.display.BitmapDataChannel;
    public class Canvas extends FlxSprite
    {
    
        [Embed (source = "../../img/canvas_1.png")] public var Canvas_1:Class;
        
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
        
        public var darkness:int = 130;
        public var buf:BitmapData;
        public var base:FlxSprite;
        public var colorIndex:int = 0;
        
        public function Canvas(size:Rectangle) 
        {
            super(size.x,size.y);
            makeGraphic(size.width, size.height, 0x00ffffff);
            
           loadGraphic(Canvas_1, false, false, 100, 100);
            
            
            base = new FlxSprite(x, y);
            base.makeGraphic(width, height, 0x00000000);
            
            buf  = new BitmapData(size.width, size.height, true, 0x00000000);
            
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
                if (hor_alpha > 0.5) { 
                    hor_alpha -= 0.01;
                } else {
                    hor_alpha = 0.5;
                }
               
                for (var i:int = 0; i < height; i++) {
                    if (pixels.getPixel32(horizontal_marker.x - x, i) != 0x00000000)
                        if (colorIndex != 2 || Math.random() < 0.5)
                            buf.setPixel32(horizontal_marker.x - x, i,  Registry.colors[colorIndex] + int(hor_alpha * darkness) * 0x01000000);
                }
                
                base.pixels.draw(buf, null, null, "add");
                
                for (var j:int = 0; j < height; j++) {
                    buf.setPixel32(horizontal_marker.x - x, j , 0x00000000);
                }
                
                base.dirty = true;
            } else {
                hor_alpha = 0.9;
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
                if (vert_alpha > 0.5) { 
                    vert_alpha -= 0.01;
                } else {
                    vert_alpha = 0.5;
                }
               
                for (var i:int = 0; i < width; i++) {
                    if (pixels.getPixel32(vertical_marker.y - y,i) != 0x00000000)
                    buf.setPixel32(i, vertical_marker.y - y,  Registry.colors[colorIndex] + int(vert_alpha * darkness) * 0x01000000);
                }
                
                base.pixels.draw(buf, null, null, "add");
                
                
                for (var j:int = 0; j < width; j++) {
                    buf.setPixel32(j, vertical_marker.y - y , 0x00000000);
                }
                
                base.dirty = true;
            } else {
                vert_alpha = 0.9;
            }
               
       }
        
    }

}