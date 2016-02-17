/*
  Copyright (C) 2015-2016 jollailija
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

  This file has parts copied from Nettiradio (jollailija's app).
*/

import QtQuick 2.1
import Sailfish.Silica 1.0
import QtQuick.LocalStorage 2.0
import "storage.js" as Storage

Page {
    id: bookmarkPage
    property bool editMode: false
    property bool searchMode: false
    property string name
    property string url
    property string searchString

    function loadList() {
        bookmarkModel.clear()
        Storage.initialize()
        Storage.getBookmarksFromDB(bookmarkModel)
        console.log("Updated bookmark model")
    }

    function getSortedItems(searchTerm) {
        filteredModel.clear()
        for (var i = 0; i < bookmarkModel.count; i++) {
            if (searchTerm === "" || bookmarkModel.get(i).name.toLowerCase().indexOf(searchTerm) !== -1) {
                filteredModel.append(bookmarkModel.get(i))
            }
        }
    }

    ListModel {
        id: bookmarkModel
    }
    ListModel {
        id: filteredModel
    }

    SilicaListView {
        id: bookmarkList
        PullDownMenu {
            // Disabled for now
            /*MenuItem {
                text: bookmarkPage.editMode ? qsTr("Disable re-arranging") : qsTr("Enable re-arranging")
                onClicked: {
                    bookmarkPage.editMode ? bookmarkPage.editMode = false
                                          : bookmarkPage.editMode = true
                }
            }*/
            MenuItem {
                text: bookmarkPage.searchMode ? qsTr("Hide search") : qsTr("Search")
                onClicked: {
                    bookmarkPage.searchMode ? bookmarkPage.searchMode = false
                                            : bookmarkPage.searchMode = true
                }
            }
            MenuItem {
                text: qsTr("Add current page to bookmarks:")
                onClicked: {
                    Storage.initialize()
                    Storage.addBookmark(name, url)
                    console.log("Added bookmark " + name + " : " + url)
                    loadList()
                }
            }
            MenuLabel {
                text: bookmarkPage.name
            }
        }
        VerticalScrollDecorator {}
        anchors.fill: parent
        header: Loader {
            width: parent.width

            sourceComponent: bookmarkPage.searchMode ? search : header

            Component {
                id: header
                PageHeader {
                    title: qsTr("Bookmarks")
                }
            }

            Component {
                id: search

                SearchField {
                    id: searchField
                    //visible: mainPage.searchMode
                    anchors.top: parent.top
                    width: parent.width
                    onTextChanged: {
                        searchString=searchField.text.toLowerCase()
                        getSortedItems(searchString)
                        //listView.positionViewAtIndex(0,ListView.Beginning)
                    }
                    inputMethodHints: Qt.ImhNoPredictiveText
                    placeholderText: qsTr("Search...")
                    EnterKey.onClicked: {
                        focus = false
                    }
                }
            }

        }

        ViewPlaceholder {
            enabled: !bookmarkPage.searchMode && bookmarkModel.count === 0
            text: qsTr("No bookmarks")
            hintText: qsTr("Pull down to add current page to bookmarks")
        }
        ViewPlaceholder {
            enabled: bookmarkPage.searchMode && filteredModel.count === 0
            text: qsTr("Nothing was found")
            hintText: qsTr("Try a different search term")
        }
        model: bookmarkPage.searchMode ? filteredModel : bookmarkModel


        delegate: ListItem {
            id: delegate
            width: parent.width
            onClicked: {
                window.webViewUrl = model.url
                console.log("model.url "+model.url)
                pageStack.pop(undefined, PageStackAction.Immediate)
            }
            Label {
                text: Theme.highlightText(model.name, searchString, Theme.highlightColor)
                textFormat: Text.StyledText
                color: highlighted ? Theme.highlightColor : Theme.primaryColor
                font.pixelSize: Screen.sizeCategory > Screen.Medium
                                ? Theme.fontSizeExtraLarge
                                : Theme.fontSizeMedium
                anchors.verticalCenter: parent.verticalCenter
                x: Theme.paddingLarge
                truncationMode: TruncationMode.Elide
                width: bookmarkPage.editMode ? parent.width - ((moveUp.width * 2) + (Theme.paddingLarge * 2))
                                             : parent.width - Theme.paddingLarge
            }
            menu: ContextMenu {
                MenuLabel {
                    text: qsTr("Warning: deleting is instant")
                }
                MenuItem {
                    text: qsTr("Delete")
                    onClicked: {
                        Storage.initialize()
                        Storage.deleteBookmark(model.name)
                        loadList()
                    }
                }
            }
        }
        /*IconButton {
            id: moveUp
            anchors {
                right: moveDown.left
            }
            icon.source: "image://theme/icon-m-up"
            onClicked: bookmarkModel.move(model.index, model.index-1, 1)
            enabled: bookmarkPage.editMode && (index > 0)
            opacity: bookmarkPage.editMode ? 1.0 : 0.0
        }
        IconButton {
            id: moveDown
            anchors {
                right: parent.right
                rightMargin: Theme.paddingLarge
            }
            icon.source: "image://theme/icon-m-down"
            onClicked: bookmarkModel.move(model.index, model.index+1, 1)
            enabled: bookmarkPage.editMode && (index < bookmarkModel.count-1)
            opacity: bookmarkPage.editMode ? 1.0 : 0.0
        }*/
        Component.onCompleted: loadList()
    }
}
