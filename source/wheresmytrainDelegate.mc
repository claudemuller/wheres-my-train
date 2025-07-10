import Toybox.Lang;
import Toybox.WatchUi;

class wheresmytrainDelegate extends WatchUi.BehaviorDelegate {
    private var _notify as Method(args as Array or String or Null) as Void;
    private var _siteID = 3490;

    public function initialize(handler as Method(args as Array or String or Null) as Void) {
        BehaviorDelegate.initialize();
        _notify = handler;
    }

    function onMenu() as Boolean {
        //WatchUi.pushView(new Rez.Menus.MainMenu(), new wheresmytrainMenuDelegate(), WatchUi.SLIDE_UP);
        makeRequest();
        return true;
    }

    public function onSelect() as Boolean {
        makeRequest();
        return true;
    }

    private function makeRequest() as Void {
        _notify.invoke("Executing\nRequest");

        var options = {
            :responseType => Communications.HTTP_RESPONSE_CONTENT_TYPE_JSON,
            :headers => {
                "Content-Type" => Communications.REQUEST_CONTENT_TYPE_URL_ENCODED
            }
        };

        Communications.makeWebRequest(
            format("https://transport.integration.sl.se/v1/sites/$1$/departures", [_siteID]),
            null,
            options,
            method(:onReceive)
        );
    }

    public function onReceive(responseCode as Number, data as Dictionary or String or Null) as Void {
        var result = [];

        if (responseCode == 200) {
            if (!(data instanceof Dictionary)) {
                System.println("error: unexpected response - not dict");
                return;
            }
                
            if (!data.hasKey("departures")) {
                  System.println("error: unexpected response - no departures");
                 return;
            }

            var deps = data["departures"];
            if (!(deps instanceof Array)) {
                 System.println("error: unexpected response - departures not array");
                 return;
             }

            for (var i = 0; i < deps.size(); i++) {
                //System.println(deps.size().toString());
                
                var d = deps[i];
                //System.println(d.toString());
                
                if (!(d instanceof Dictionary)) {
                    System.println("error: unexpected response - departure entry not dict");
                    continue;
                }

                if (!d.hasKey("stop_area")) {
                    System.println("error: unexpected response - departure entry has no 'stop_area'");
                    continue;
                }

                var stopArea = d["stop_area"];
                if (!(stopArea instanceof Dictionary)) {
                    System.println("error: unexpected response - stop_area entry not dict");
                    continue;
                }

                if (!stopArea.hasKey("type")) {
                    System.println("error: unexpected response - stop_area has no 'type'");
                    continue;
                }
                
                var stopType = stopArea["type"];
                if (!(stopType instanceof String)) {
                    System.println("error: unexpected response - stop_type not string");
                    continue;
                }

                if (stopType.equals("METROSTN")) {
                    var lineNo = -1;
                    var line = d["line"];
                    if (line instanceof Dictionary) {
                        lineNo = line["id"];
                    }
                    var res = format("L$1$ to $2$ in $3$", [lineNo, d["destination"], d["display"]]);
                    System.println(res);

                    result.add(res);
                }
            }

            _notify.invoke(result);
        } else {
            _notify.invoke("Failed to load\nError: " + responseCode.toString());
        }
    }
}