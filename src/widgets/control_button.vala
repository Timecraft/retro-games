public class Timecraft.RetroGame.ControlButton : Gtk.Button {
    
    public ControlButton (MainWindow main_window) {
        
        Gtk.Image controller_icon = new Gtk.Image.from_icon_name ("com.github.timecraft.retro", Gtk.IconSize.LARGE_TOOLBAR);
        controller_icon.pixel_size = 24;
        controller_icon.icon_name = "input-gaming";
        
        Object (
            image: controller_icon,
            always_show_image: true,
            label: "Set up controls",
            tooltip_text: "Set up controls"
        );
        
        clicked.connect ( () => {
            new ControlWindow (main_window);
        });
    }
}
