package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxTimer;

class PlayState extends FlxState
{
	public var player:Player;

	public static var default_zoom:Float = 0.375;

	var grid_bg:FlxSprite;

	public var debugMode:Bool = false;

	var game_cam:FlxCamera;
	var player_cam:FlxCamera;
	var bullet_cam:FlxCamera;
	var grid_cam:FlxCamera;

	override public function create()
	{
		game_cam = new FlxCamera();
		FlxG.cameras.reset(game_cam);

		grid_cam = new FlxCamera();
		grid_cam.bgColor.alpha = 0;
		FlxG.cameras.add(grid_cam);

		bullet_cam = new FlxCamera();
		bullet_cam.bgColor.alpha = 0;
		FlxG.cameras.add(bullet_cam);

		player_cam = new FlxCamera();
		player_cam.bgColor.alpha = 0;
		FlxG.cameras.add(player_cam);

		FlxCamera.defaultCameras = [game_cam];

		FlxG.camera.zoom = default_zoom;
		grid_cam.zoom = default_zoom;
		bullet_cam.zoom = default_zoom;
		player_cam.zoom = default_zoom;

		FlxG.camera.bgColor = 0xFF7F7F7F;

		grid_bg = new FlxSprite().loadGraphic('assets/images/grid.png');
		add(grid_bg);
		grid_bg.cameras = [grid_cam];
		grid_bg.updateHitbox();
		grid_bg.antialiasing = true;

		player = new Player();
		add(player.spr);
		add(player.hitbox);
		player.spr.cameras = [player_cam];
		player.hitbox.cameras = [player_cam];
		player.camera_effect = FlxG.camera;

		FlxG.camera.follow(player.spr, LOCKON);
		FlxG.camera.focusOn(player.spr.getPosition());

		grid_cam.follow(player.spr, LOCKON);
		grid_cam.focusOn(player.spr.getPosition());

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (FlxG.keys.justPressed.Q)
			debugMode = !debugMode;

		player.hitbox.alpha = debugMode ? 0.5 : 0;

		FlxG.camera.follow(player.spr, LOCKON, 0.04);

		player.hitbox.setPosition(player.spr.x, player.spr.y);

		if (!FlxG.overlap(player.spr, grid_bg))
		{
			if (player.hitbox.x < grid_bg.x)
				player.spr.x += 2.5;
			else if (player.hitbox.x > grid_bg.x + grid_bg.width)
				player.spr.x -= 2.5;

			if (player.hitbox.y < grid_bg.y)
				player.spr.y += 2.5;
			else if (player.hitbox.y > grid_bg.y + grid_bg.height)
				player.spr.y -= 2.5;
		}

		player.spr.angle = Math.atan2(FlxG.mouse.y - player.spr.y, FlxG.mouse.x - player.spr.x) * 180 / Math.PI;

		if (FlxG.mouse.pressed || FlxG.keys.pressed.SPACE)
		{
			if (player.can_shoot)
			{
				player.can_shoot = false;

				player.shoot_timer = 1;
				player.fire();
				new FlxTimer().start(0.12, function(tmr:FlxTimer)
				{
					add(new Bullet(player.spr.x + 25, player.spr.y + 25, player.spr.angle, FlxG.mouse.getPosition(), bullet_cam));
				});
			}
		}

		if (!player.can_shoot)
		{
			player.shoot_timer -= elapsed;
			if (player.shoot_timer <= 0)
				player.can_shoot = true;
		}

		if (FlxG.keys.pressed.A)
			player.spr.x -= 2.5;
		if (FlxG.keys.pressed.S)
			player.spr.y += 2.5;
		if (FlxG.keys.pressed.W)
			player.spr.y -= 2.5;
		if (FlxG.keys.pressed.D)
			player.spr.x += 2.5;

		FlxG.camera.zoom = FlxMath.lerp(PlayState.default_zoom, FlxG.camera.zoom, 0.95);

		super.update(elapsed);
	}
}
