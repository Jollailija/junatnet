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

    property bool zoom: false

    SilicaWebView {
        PullDownMenu {
            MenuLabel {
                text: qsTr("Junat.net WebView version ") + "2"
            }
            MenuLabel {
                text: qsTr("Current page:")
            }
            MenuLabel {
                text: webView.title
            }
            MenuItem {
                text: qsTr("Reload")
                onClicked: {
                    console.log("Reload")
                    webView.reload()
                }
            }
            MenuItem {
                text: page.zoom ? qsTr("Smaller font (text won't overlap)") : qsTr("Bigger font (text may overlap)")
                onClicked: {
                    page.zoom ? page.zoom = false : page.zoom = true
                    webView.reload()
                }
            }
            MenuItem {
                text: qsTr("Bookmarks")
                onClicked: {
                    console.log("Opening bookmarks")
                    pageStack.push(Qt.resolvedUrl("BookmarkPage.qml"),{"name": webView.title, "url": webView.url})
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
        url: window.webViewUrl
        quickScroll : true
        experimental.userScripts: [
            page.zoom ? Qt.resolvedUrl("devicePixelRatioHack.js") : Qt.resolvedUrl("devicePixelRatioHack2.js"),
        ]
    }
}
