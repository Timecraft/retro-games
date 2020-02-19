public class Timecraft.RetroGame.RetroInput : GLib.Object, Retro.Controller {
    
    public Manette.Device device { get; construct; }

    private bool[] buttons;
    private int16[] axes;
    private uint16 rumble_effect[2];
    
    public RetroInput (Manette.Device device) {
        Object (
            device: device
        );
    }
    
}
