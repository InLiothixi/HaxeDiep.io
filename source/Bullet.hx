package;

import flixel.FlxCamera;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxAngle;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

using StringTools;

class Bullet extends FlxSprite
{
	public var time_decay:Float = 2.0;
	public var has_fired:Bool = false;
	public var target:FlxPoint;

	public function new(x:Float, y:Float, _angle:Float, _target:FlxPoint, ?_camera:FlxCamera)
	{
		super(x, y);

		if (_camera != null)
			camera = _camera;

		angle = _angle;

		target = _target;

		frames = FlxAtlasFrames.fromSparrow(AssetPaths.bullets__png, AssetPaths.bullets__xml);
		animation.addByPrefix('fire', 'bullet_fired', 24, false);
		animation.play('fire');
		velocity.set(1000, 0);
		velocity.rotate(FlxPoint.weak(0, 0), FlxAngle.angleBetweenPoint(this, target, true));

		new FlxTimer().start(time_decay, function(tmr:FlxTimer)
		{
			destroy();
		});
	}
}
