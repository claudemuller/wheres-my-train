import Toybox.Application;
import Toybox.WatchUi;
import Toybox.Communications;
import Toybox.Lang;
import Toybox.Position;

class wheresmytrainApp extends AppBase {
    private var _view as wheresmytrainView;

    function initialize() {
        AppBase.initialize();
        _view = new $.wheresmytrainView();
    }

    // onStart() is called on application start up
    function onStart(state) as Void {
        System.println("device started");
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    }

    // onStop() is called when your application is exiting
    function onStop(state) as Void {
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    public function onPosition(info as Info) as Void {
        _view.setPosition(info);
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        var delegate = new $.wheresmytrainDelegate(_view.method(:onReceive));
        return [_view, delegate];
    }
}