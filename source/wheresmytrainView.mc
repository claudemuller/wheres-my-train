using Toybox.Graphics as Gfx;
import Toybox.WatchUi;
using Toybox.Application as App;
import Toybox.Position;
import Toybox.Lang;

class wheresmytrainView extends View {
    private var _lines as Array<String>;
    private var _message = "Press menu or\nstart to sync";

    function initialize() {
        View.initialize();
        _lines = ["No position info"];
    }

    // Load your resources here
    function onLayout(dc as Gfx.Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Gfx.Dc) as Void {
        //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        //dc.clear();

        //dc.drawText(dc.getWidth() / 2, dc.getHeight() / 2, Graphics.FONT_TINY, _message, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);

        // Set background color
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        var x = dc.getWidth() / 2;
        var y = dc.getHeight() / 2;

        var font = Graphics.FONT_SMALL;
        var textHeight = dc.getFontHeight(font);

        y -= (_lines.size() * textHeight) / 2;

        for (var i = 0; i < _lines.size(); ++i) {
            dc.drawText(x, y, Graphics.FONT_SMALL, _lines[i], Graphics.TEXT_JUSTIFY_CENTER);
            y += textHeight;
        }

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    public function setPosition(info as Info) as Void {
        _lines = [];

        var position = info.position;
        if (position != null) {
            _lines.add("lat = " + position.toDegrees()[0].toString());
            _lines.add("lon = " + position.toDegrees()[1].toString());
        }

        var speed = info.speed;
        if (speed != null) {
            _lines.add("speed = " + speed.toString());
        }

        var altitude = info.altitude;
        if (altitude != null) {
            _lines.add("alt = " + altitude.toString());
        }

        var heading = info.heading;
        if (heading != null) {
            _lines.add("heading = " + heading.toString());
        }

        WatchUi.requestUpdate();
    }

    public function onReceive(args as Array or String or Null) as Void {
        _message = "";

        if (args == null) {
            _message = "No data :(";
            WatchUi.requestUpdate();
            return;
        }

        if (args instanceof String) {
            _message = args;
            WatchUi.requestUpdate();
            return;
        }

        if (args instanceof Array) {
            for (var i = 0; i < args.size(); i++) {
                _message += Lang.format("$1$\n", [args[i]]);
            }
            WatchUi.requestUpdate();
            return;
        }
    }
}
