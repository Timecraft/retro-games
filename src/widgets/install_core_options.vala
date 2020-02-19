public class Timecraft.RetroGame.InstallCoreOptions : Granite.Widgets.Welcome {
    public InstallCoreOptions () {
        Object (
            title: "Install Core",
            subtitle: ""
        );
        // Set up custom icon
        Gtk.Image input_gaming_new = new Gtk.Image.from_icon_name ("com.github.timecraft.retro", Gtk.IconSize.INVALID);
        input_gaming_new.pixel_size = 128;
        input_gaming_new.margin_bottom = 12;
        input_gaming_new.icon_name = "input-gaming-new";
        
        append_with_image (input_gaming_new, "Install for a new console", "This emulates a console that is not yet installed");
        if (Application.instance.systems [0] != null) {
            append ("input-gaming", "Install for existing console", "This core emulates a console that is already installed");
        }
        
        
        
        activated.connect ( (index) => {
            
            switch (index) {
                case 0:
                    
                    InstallCore.instance.new_console ();
                    break;
                
                case 1:
                    InstallCore.instance.existing_console ();
                    break;
                    
            }
            /*
            
            */
        });
        
        
        
    }
}
