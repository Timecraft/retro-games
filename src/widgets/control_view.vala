public class Timecraft.RetroGame.ControlView : Gtk.DrawingArea {
    
    
    
    private GLib.Bytes data;
    
    private Rsvg.Handle handle;

    private Gdk.Pixbuf main_pixbuf;
    
    private Cairo.Context context;
    private Cairo.Surface surface;

    
    public ControlView () {
        
        set_size_request (512, 512);
        try {
            GLib.Bytes bytes = GLib.resources_lookup_data ("/com/github/timecraft/retro/controller-outline.svg", GLib.ResourceLookupFlags.NONE); 
            
            uint8[] data = bytes.get_data ();
            
            handle = new Rsvg.Handle.from_data (data);
        }
        catch (Error e) {
            critical (e.message);
        }
        
        


    }
    
    public override bool draw (Cairo.Context context) {
        change_pixbuf (context);
        return false;
    }
    
    private void change_pixbuf (Cairo.Context context) {
        context.push_group ();
        handle.render_cairo (context);
        var group = context.pop_group ();
        
        Gdk.RGBA color;
	    get_style_context ().lookup_color ("theme_fg_color", out color);
	    context.set_source_rgba (color.red, color.green, color.blue, color.alpha);
	    context.mask (group);
            
        
    }
    
    /**
    *   Reads an svg file in your gresources.xml file.
    *   Returns a string holding the contents of the svg file.
    *    
    *   @param svg_resource The path to your svg file in your resources
    *   
    *
    */
    /*
    private string read_svg (string svg_resource) throws Error {
        GLib.Bytes bytes = GLib.resources_lookup_data (svg_resource);
        uint8[] data = bytes.get_data ();
        string svg_file = "";
        foreach (uint8 byte in data) {
            svg_file += ((char) byte).to_string ();
        }
        return svg_file;
    }
    */
    
    public Gdk.Pixbuf get_pixbuf () {
        return main_pixbuf;
    }
    
     
}
