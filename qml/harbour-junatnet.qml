import QtQuick 2.0
import Sailfish.Silica 1.0
import "pages"

ApplicationWindow
{
    id: window
    initialPage: Component { FirstPage { } }
    property string webViewUrl: "http://www.junat.net/"
    cover: undefined
    allowedOrientations: Orientation.All
    _defaultPageOrientations: Orientation.All
}
