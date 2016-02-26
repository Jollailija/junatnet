/*
  Copyright (C) 2016 jollailija
  Contact: jollailija <jollailija@gmail.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * The names of the contributors may not be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import QtWebKit 3.0
import QtQuick.LocalStorage 2.0
import "storage.js" as Storage

Page {
    id: page
    allowedOrientations: Orientation.All
    BookmarkPage {id: bookmarkPage} // just don't. I know it's wrong, but the freaking bug won't die!

    property bool zoom: false // This is for choosing the pixelratiohack

    DockedPanel {
        id: navPanel
        dock: Dock.Bottom
        width: parent.width
        height: Theme.itemSizeSmall
        open: true // todo: open and close on scroll
        _immediate: true // no lag when opening or closing

        Row {
            anchors.centerIn: parent
            spacing: Theme.paddingLarge
            IconButton {
                icon.source: "image://theme/icon-m-back"
                onClicked: webView.goBack()
                enabled: webView.canGoBack
            }
            IconButton {
                icon.source: "image://theme/icon-m-refresh"
                onClicked: webView.reload()
            }
            IconButton {
                icon.source: "image://theme/icon-m-train"
                // lol, the train image is perfect for this!
                // here's a generic home icon:
                // "image://theme/icon-m-home"
                onClicked: webView.url = "http://www.junat.net/"
            }
            IconButton {
                icon.source: "image://theme/icon-m-favorite"
                onClicked: pageStack.push(bookmarkPage,{"name": webView.title, "url": webView.url})
            }
            IconButton {
                icon.source: "image://theme/icon-m-forward"
                onClicked: webView.goForward()
                enabled: webView.canGoForward
            }
        }
    }

    // Rewritten for easier readability: all important stuff is at the top
    SilicaWebView {
        id: webView
        anchors {
            fill: parent
            bottomMargin: navPanel.visibleSize
        }
        url: "http://www.junat.net/"
        PullDownMenu {
            MenuLabel {
                text: qsTr("Junat.net WebView version") + " 4"
            }
            MenuItem {
                text: page.zoom ? qsTr("Smaller font (text won't overlap)")
                                : qsTr("Bigger font (text may overlap)")
                onClicked: {
                    page.zoom ? page.zoom = false : page.zoom = true
                    webView.reload()
                }
            }
            MenuItem {
                text: navPanel.open ? qsTr("Hide navigation bar")
                                : qsTr("Open navigation bar")
                onClicked: {
                    navPanel.open ? navPanel.open = false : navPanel.open = true
                }
            }
            MenuLabel {
                text: qsTr("Current page:")
            }
            MenuLabel {
                text: webView.title
            }
            /*MenuItem {
                text: qsTr("Reload")
                onClicked: {
                    console.log("Reload")
                    webView.reload()
                }
            }*/
            /*MenuItem {
                text: qsTr("Bookmarks")
                onClicked: {
                    pageStack.push(bookmarkPage,{"name": webView.title, "url": webView.url})
                }
            }
            MenuItem {
                text: qsTr("Back to junat.net")
                onClicked: {
                    console.log("Back to junat.net")
                    webView.url = "http://www.junat.net/"
                }
            }*/
        }
        BusyIndicator {
            anchors.centerIn: parent
            running: webView.loading
            size: BusyIndicatorSize.Large
        }
        experimental.userScripts: [
            page.zoom ? Qt.resolvedUrl("devicePixelRatioHack.js") : Qt.resolvedUrl("devicePixelRatioHack2.js"),
        ]
    }
}
