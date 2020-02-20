public class Timecraft.RetroGame.View : GLib.Object {

    public Retro.CoreView game_view;

    public View (Retro.Core core) {
        game_view = new Retro.CoreView ();
        
        game_view.set_core (core);
        

        
        MainWindow.instance.add (game_view);
        
        game_view.set_key_joypad_mapping (null);
        
        var key_joypad_mapping = new Retro.KeyJoypadMapping ();
        GLib.HashTable<Retro.JoypadId, uint16> key_map = new GLib.HashTable<Retro.JoypadId, uint16> (null, null);
        
        key_map.insert (Retro.JoypadId.A,       (uint16) Gdk.Key.x);
        key_map.insert (Retro.JoypadId.B,       (uint16) Gdk.Key.z);
        key_map.insert (Retro.JoypadId.Y,       (uint16) Gdk.Key.a);
        key_map.insert (Retro.JoypadId.X,       (uint16) Gdk.Key.s);
        key_map.insert (Retro.JoypadId.UP,      (uint16) Gdk.Key.Up);
        key_map.insert (Retro.JoypadId.DOWN,    (uint16) Gdk.Key.Down);
        key_map.insert (Retro.JoypadId.LEFT,    (uint16) Gdk.Key.Left);
        key_map.insert (Retro.JoypadId.RIGHT,   (uint16) Gdk.Key.Right);
        key_map.insert (Retro.JoypadId.START,   (uint16) Gdk.Key.Return);
        key_map.insert (Retro.JoypadId.SELECT,  (uint16) Gdk.Key.Shift_R);
        
        key_map.foreach ( (joypad, keyboard) => {
            key_joypad_mapping.set_button_key (joypad, keyboard);
        });
        
        game_view.set_key_joypad_mapping (key_joypad_mapping);
        
        core.set_default_controller (Retro.ControllerType.KEYBOARD, null);
        
        game_view.set_as_default_controller (core);
        
        core.set_keyboard (game_view);
        
        
        //core.set_default_controller (Retro.ControllerType.JOYPAD, null);

        Retro.MainLoop main_loop = new Retro.MainLoop (core);
        main_loop.start ();
        try {
            core.boot ();
        }
        catch (Error e) {
            error ("%s", e.message);
        }
        
        core.run ();
        Headerbar.instance.remove_back_button ();
        
        MainWindow.instance.show_all ();
    }
}
