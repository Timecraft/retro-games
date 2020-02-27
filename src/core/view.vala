// Thanks to https://github.com/Exalm for fixing this file :D

public class Timecraft.RetroGame.View : GLib.Object {

    public Retro.CoreView game_view;
    public Retro.MainLoop main_loop;

    

    public View (Retro.Core core, MainWindow main_window) {
        game_view = new Retro.CoreView ();

        game_view.set_core (core);

        var key_joypad_mapping = main_window.key_joypad_mapping;

        
        if (key_joypad_mapping == null) {
            critical ("There is no KeyJoypadMapping set up!");
        }


        game_view.set_key_joypad_mapping (key_joypad_mapping);

        game_view.set_as_default_controller (core);

        // This keyboard input is different from Retro.ControllerType.KEYBOARD, you mostly
        // need it for home computer platforms. Yay Libretro having multiple APIs for things
        core.set_keyboard (game_view);

        // This is needed so that you only control the first player with joypad, and not all
        // at once. For other players assign the actual gamepads. In Games we use keyboard
        // for the last one (e.g. if you have 2 gamepads in a 4-player game, players 1 and 2
        // will use gamepads, player 3 will use keyboard, player 4 will just stand there)
        if (main_window.gamepad == null) {
            core.set_default_controller (Retro.ControllerType.JOYPAD, null);
            var core_view_joypad = game_view.as_controller (Retro.ControllerType.JOYPAD);
            core.set_controller (0, core_view_joypad);
        }
        else {
            core.set_default_controller (Retro.ControllerType.JOYPAD, null);
            core.set_controller (0, main_window.gamepad);
        }

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

        main_window.headerbar.remove_back_button ();

        main_window.show_all ();

        
    }
}
