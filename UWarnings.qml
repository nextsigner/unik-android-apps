import QtQuick 2.0

Rectangle{
    id: xUWarnings
    width: app.width-app.fs
    height:parent.height
    color: app.c1
    border.width: unikSettings.borderWidth
    border.color: app.c2
    visible: false
    clip: true
    property bool notShowAgain: false
    Connections {
        target: unik
        onUWarningChanged: {
            txtErrors.text+=''+unik.getUWarning()+'\n\n';
            if(!xUWarnings.notShowAgain){
                xUWarnings.visible=true
            }
        }
    }
    Timer{
        running: true
        repeat: true
        interval: 3000
        onTriggered: xUWarnings.setUData()
    }
    Flickable{
        width: parent.width-app.fs
        height: parent.height-app.fs
        contentWidth: txtErrors.contentWidth
        contentHeight: txtErrors.contentHeight
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: app.fs
        Text {
            id: txtErrors
            text: unikSettings.lang==='es'?'<b>Unik Advertencias</b><br /><br />':'<b>Unik Warnings</b><br /><br />'
            font.pixelSize: app.fs
            color: app.c2
            width: xUWarnings.width-app.fs*3
            wrapMode: Text.WordWrap
        }
    }
    Boton{//Close
        id: btnCloseXUWarning
        w:app.fs
        h: w
        t: "\uf00d"
        d:unikSettings.lang==='es'?'Cerrar':'Close'
        b:app.c1
        c: app.c2
        anchors.right: parent.right
        anchors.rightMargin: app.fs*0.5
        anchors.top: parent.top
        anchors.topMargin: app.fs*0.5
        onClicking: {
            xUWarnings.visible=false
        }
    }
    Boton{//Close for ever
        id: btnCloseXUWarningNotAgain
        w:app.fs
        h: w
        t: "\uf011"
        d:unikSettings.lang==='es'?'Cerrar - No mostrar mas':'Close - Not Show Again'
        b:app.c1
        c: app.c2
        anchors.right: btnCloseXUWarning.right
        anchors.top: btnCloseXUWarning.bottom
        anchors.topMargin: app.fs*0.5
        onClicking: {
            xUWarnings.notShowAgain=true
            xUWarnings.visible=false
        }
    }
    Boton{//Clear
        id: btnCloseXUWarningClear
        w:app.fs
        h: w
        t: "\uf12d"
        d:unikSettings.lang==='es'?'Limpiar':'Clear'
        b:app.c1
        c: app.c2
        anchors.right: btnCloseXUWarningNotAgain.right
        anchors.top: btnCloseXUWarningNotAgain.bottom
        anchors.topMargin: app.fs*0.5
        onClicking: {
            txtErrors.text=unikSettings.lang==='es'?'<b>Unik Advertencias</b><br /><br />':'<b>Unik Warnings</b><br /><br />'
        }
    }
}
