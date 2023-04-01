package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;

using StringTools;

class Player
{
	public var health:Float = 1;
	public var spr:FlxSprite;

	public var camera_effect:FlxCamera;
	public var hitbox:FlxSprite;
	public var can_shoot:Bool = true;
	public var shoot_timer:Float = 0;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		spr = new FlxSprite(x, y);
		spr.frames = getFrames('tank');
		spr.antialiasing = true;
		spr.animation.addByPrefix('static', 'tank static', 60, false);
		spr.animation.addByPrefix('fire', 'tank fire', 60, false);
		spr.animation.play('static');
		spr.centerOffsets();
		spr.origin.set(50, 50);
		spr.offset.x = 0;
		spr.offset.y = 0;

		hitbox = new FlxSprite().makeGraphic(100, 100, 0xFF0000FF);
		hitbox.updateHitbox();
	}

	public function fire():Void
	{
		if (camera_effect != null && spr.animation.curAnim.finished && spr.animation.curAnim.name == 'fire')
			doCameraEffect();

		spr.animation.play('fire', true);
		spr.centerOffsets();
		spr.origin.set(55.5, 55.5);
		spr.offset.x = 5.5;
		spr.offset.y = 5.5;

		if (spr.animation.curAnim.finished && spr.animation.curAnim.name == 'fire')
		{
			spr.animation.play('static');
			spr.centerOffsets();
			spr.origin.set(50, 50);
			spr.offset.x = 0;
			spr.offset.y = 0;
		}
	}

	function getFrames(frame:String):FlxAtlasFrames
	{
		if (frame == null)
			return null;

		return FlxAtlasFrames.fromSparrow('assets/images/${frame}.png', 'assets/images/${frame}.xml');
	}

	function doCameraEffect():Void
	{
		if (camera_effect.zoom < PlayState.default_zoom + .01)
			camera_effect.zoom += 0.005;
	}
}
