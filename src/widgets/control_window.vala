public class Timecraft.RetroGame.ControlWindow : Gtk.Window {
    public Manette.Monitor monitor;
    
    // public RetroInput controller;
    
    public Gtk.Image controller_image;
    
    private Gtk.CssProvider css_provider;
    
    private Gtk.Grid window_grid;
    
    private Gtk.Button control_setup;
    
    public ControlWindow () {
        Object (
            title: "Set up controls"
        );
        
        window_grid = new Gtk.Grid ();
        
        css_provider = new Gtk.CssProvider ();
        css_provider.load_from_resource ("com/github/timecraft/retro/Application.css");
        Gtk.StyleContext.add_provider_for_screen (Gdk.Screen.get_default (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);
        
        controller_image = new Gtk.Image.from_icon_name ("com.github.timecraft.retro", Gtk.IconSize.DIALOG);
        controller_image.pixel_size = 512;
        
        controller_image.icon_name = "controller-outline";
        
        //controller_image.get_style_context ().add_class ("controller-button");
        
        control_setup = new Gtk.Button.with_label ("Set up controller");
        
        control_setup.margin = 20;
        
        window_grid.attach (controller_image, 0, 0, 5, 3);
        
        window_grid.attach (control_setup, 2, 3, 1, 1);
        
        control_setup.clicked.connect ( () => {
            controller_image.icon_name = "controller-button-primary";
        });
        
        
        add (window_grid);
        
        show_all ();
    }
    
}
