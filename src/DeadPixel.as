package {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageOrientation;
import flash.events.MouseEvent;
import flash.sampler.NewObjectSample;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.utils.setTimeout;

public class DeadPixel extends Sprite
    {
        private var bmd:BitmapData;
        private var surroundCoords:Array = [[-1, -1], [-1, 0], [-1, 1],
                                            [0, -1], [0, 1],
                                            [1, -1], [1, 0], [1, 1]];



        public function DeadPixel()
        {

            trace(stage.width);
            trace(stage.height);


            var textField:TextField = new TextField();
            textField.text = "Hello, World";

            addChild(textField);

            var resX:int = Capabilities.screenResolutionX;
            var resY:int = Capabilities.screenResolutionY;

            addEventListener(MouseEvent.MOUSE_MOVE, function(e:MouseEvent) : void {
               trace(mouseX);
               trace(mouseY);
            });


            trace(resX);
            trace(resY);

            bmd = new BitmapData(480, 762, false, 0x000000);
            var bitmap:Bitmap = new Bitmap(bmd);

            addChild(bitmap);

            var randomX:int = Math.random() * bmd.width;
            var randomY:int = Math.random() * bmd.height;
            var infected:Object = {"x" : randomX, "y" : randomY};
            bitmap.bitmapData.setPixel(infected.x, infected.y, 0xFF0000);

            infectNeighbours(infected);
        }

        private function infectNeighbours(infectedPixel:Object) : void
        {
            var index:int = Math.random() * 8;
            var newX:int = surroundCoords[index][0] + infectedPixel.x;
            var newY:int = surroundCoords[index][1] + infectedPixel.y;
            var newInfectedPixel:Object = {"x" : surroundCoords[index][0] + infectedPixel.x, "y": surroundCoords[index][1] + infectedPixel.y};
            bmd.setPixel(infectedPixel.x, infectedPixel.y, 0xFF0000);

            trace("infecting: " + newInfectedPixel.x + " and " + newInfectedPixel.y);

            setTimeout(function() : void {
                infectNeighbours(newInfectedPixel);
            }, 1);
        }
    }


}
