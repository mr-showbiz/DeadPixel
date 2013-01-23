package {

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Sprite;
import flash.display.StageOrientation;
import flash.events.MouseEvent;
import flash.sampler.NewObjectSample;
import flash.system.Capabilities;
import flash.text.TextField;
import flash.utils.getTimer;
import flash.utils.setTimeout;

public class DeadPixel extends Sprite
    {
        private var bmd:BitmapData;
        private var surroundCoords:Array = [[-1, -1], [-1, 0], [-1, 1],
                                            [0, -1], [0, 1],
                                            [1, -1], [1, 0], [1, 1]]; //

        private var infectedPixels:Array = [];


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

            infectedPixels.push([infected.x, infected.y]);

            infectNeighbours();
        }

        private function infectNeighbours() : void
        {
            var s:Number = getTimer();
            var iterablePixels:Array = infectedPixels.concat();

            for each(var currentPixel:Array in iterablePixels)
            {
//                trace("Pixels: " + iterablePixels.length);
                var alreadyInfected:Boolean = true;
                var surroundPixels:Array = surroundCoords.concat();
                while (alreadyInfected && surroundPixels.length > 0)
                {
                    var index:int = Math.random() * surroundPixels.length;
                    var newX:int = surroundCoords[index][0] + currentPixel[0];
                    var newY:int = surroundCoords[index][1] + currentPixel[1];

                    if(newX < 0) newX = 0;
                    if(newY < 0) newY = 0;
                    if(newX > bmd.width) newX = bmd.width;
                    if(newY > bmd.height) newY = bmd.height;

                    if (bmd.getPixel(newX, newY) == 0xFF0000)
                    {
                        surroundPixels.splice(index, 1);
                    }
                    else
                    {
                        alreadyInfected = false;
                    }
                }

                if(surroundPixels.length != 0)
                {
                    var newInfectedPixel:Object = {"x" : newX, "y": newY};
                    bmd.setPixel(newInfectedPixel.x, newInfectedPixel.y, 0xFF0000);

//                    trace("infecting: " + newInfectedPixel.x + " and " + newInfectedPixel.y);

                    infectedPixels.push([newInfectedPixel.x, newInfectedPixel.y]);
                }
                else
                {
                    infectedPixels.splice(infectedPixels.indexOf(currentPixel), 1);
                }
            }

            setTimeout(function() : void {
                infectNeighbours();
            }, 50);

            trace("TIME TAKEN: " + (getTimer() - s));
        }
    }


}
