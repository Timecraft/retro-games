// Thanks to https://github.com/Exalm for fixing this file :D

public class Timecraft.RetroGame.View : GLib.Object {

    public Retro.CoreView game_view;
    public Retro.MainLoop main_loop;

    public static View? instance;

    public View (Retro.Core core) {
    game_view = new Retro.CoreView ();

    game_view.set_core (core);



    MainWindow.instance.add (game_view);

    var key_joypad_mapping = new Retro.KeyJoypadMapping ();
    var key_map = new GLib.HashTable<Retro.JoypadId, uint16> (null, null);

    // Keycodes come from input-event-codes.h + 8 because that's what GDK does
    // Normally you allow user to remap keys, so you get this value from GDK, but not here
    // Agree it sucks and we should do something about it
    key_map.insert (Retro.JoypadId.A,       45 + 8);
    key_map.insert (Retro.JoypadId.B,       44 + 8);
    key_map.insert (Retro.JoypadId.Y,       30 + 8);
    key_map.insert (Retro.JoypadId.X,       31 + 8);
    key_map.insert (Retro.JoypadId.UP,      103 + 8);
    key_map.insert (Retro.JoypadId.DOWN,    108 + 8);
    key_map.insert (Retro.JoypadId.LEFT,    105 + 8);
    key_map.insert (Retro.JoypadId.RIGHT,   106 + 8);
    key_map.insert (Retro.JoypadId.START,   28 + 8);
    key_map.insert (Retro.JoypadId.SELECT,  54 + 8);

    key_map.foreach ( (joypad, keyboard) => {
        key_joypad_mapping.set_button_key (joypad, keyboard);
    });

    game_view.set_key_joypad_mapping (key_joypad_mapping);

    game_view.set_as_default_controller (core);

    // This keyboard input is different from Retro.ControllerType.KEYBOARD, you mostly
    // need it for home computer platforms. Yay Libretro having multiple APIs for things
    core.set_keyboard (game_view);

    // This is needed so that you only control the first player with joypad, and not all
    // at once. For other players assign the actual gamepads. In Games we use keyboard
    // for the last one (e.g. if you have 2 gamepads in a 4-player game, players 1 and 2
    // will use gamepads, player 3 will use keyboard, player 4 will just stand there)
    core.set_default_controller (Retro.ControllerType.JOYPAD, null);
    var core_view_joypad = game_view.as_controller (Retro.ControllerType.JOYPAD);
    core.set_controller (0, core_view_joypad);

    // You have to have save dir and system dir set to something.
    // Save directory is where the core saves (not all cores use saveram, a lot
    // just write a file into save directory), so you gotta have it
    core.save_directory = ".";

    // This is where firmware is. Once again, should be set to something meaningful,
    // e.g. it matters for Nestopia UE core.
    core.system_directory = ".";

    try {
        core.boot ();
    }
    catch (Error e) {
        error ("%s", e.message);
    }

    // This you of course do after you boot, can't start the game before it booted
    // Though tbh in 0.18 it might work, but that's still not something you should do
    main_loop = new Retro.MainLoop (core);
    main_loop.start ();

    Headerbar.instance.remove_back_button ();

    MainWindow.instance.show_all ();

    instance = this;
    }
}
