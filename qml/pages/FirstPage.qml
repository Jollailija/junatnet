// No licence. You can look it for free, though :)

import QtQuick 2.1
import Sailfish.Silica 1.0
import QtWebKit 3.0
import QtQuick.LocalStorage 2.0
import "storage.js" as Storage

Page {
    id: page
    allowedOrientations: Orientation.All
    Component.onCompleted: console.log(webView.url)
    SilicaWebView {
        PullDownMenu {
            MenuItem {
                text: qsTr("Reload")
                onClicked: {
                    console.log("Reload")
                    webView.reload()
                }
            }
            MenuItem {
                text: qsTr("Set page as bookmark")
                onClicked: {
                    Storage.initialize()
                    Storage.setSetting("bookmark", webView.url)
                    console.log("se bookmark "+webView.url + " " + Storage.getSetting("bookmark"))
                }
            }
            MenuItem {
                text: qsTr("Open bookmark")
                onClicked: {
                    Storage.initialize()
                    webView.url = Storage.getSetting("bookmark")
                    console.log("got bookmark "+Storage.getSetting("bookmark") + " " + webView.url)
                }
            }
            MenuItem {
                text: qsTr("Back to junat.net")
                onClicked: {
                    console.log("Back to junat.net")
                    webView.url = "http://www.junat.net/"
                }
            }
        }
        id: webView
        ViewPlaceholder {
            visible: webView.loading
            text: qsTr("Loading...")
        }

        anchors.fill: parent
        url: "http://www.junat.net/"
        quickScroll : true
        experimental.userScripts: [
            Qt.resolvedUrl("devicePixelRatioHack.js"),
        ]
    }
}
