import QtQuick 2.0
import QtGraphicalEffects 1.0
import "qrc:/"
Item{
    id:r
    width: r2.width//+app.fs
    height: r2.height//+app.fs
    property string text:'text'
    property bool animationEnabled: true
    property bool glowEnabled: true
    property bool blurEnabled: true
    property int fontSize: app.fs
    property bool canceled: false
    property string t2
    property color backgroudColor: app.c1
    property color fontColor: app.c2
    property var objToRunQml
    property string qmlCode:''
    property int speed: 100
    signal clicked
    MouseArea{
        anchors.fill: r
    }

    BotonUX{
        id:  r2
        fontSize: r.fontSize
        canceled: r.canceled
        t2: r.t2
        backgroudColor: r.backgroudColor
        fontColor: r.fontColor
        objToRunQml: r.objToRunQml
        qmlCode: r.qmlCode
        speed: r.speed
        text: r.text
        anchors.centerIn: parent
        radius: width*0.5
        opacity: 0.5
        onClicked: {
            r.clicked()
            an1.stop()
            if(!r.animationEnabled)return
            tRestartAn1.restart()
        }
        Component.onCompleted:  {
            var nr = r.width*0.5
            children[0].radius= nr
            children[0].children[0].radius= nr
            children[0].children[1].radius= nr
            children[0].children[2].radius= nr

            children[0].children[0].border.width = app.fs*0.5
            children[0].children[1].border.width =app.fs*0.5
            children[0].children[2].border.width = app.fs*0.5
            r2.radius = nr
        }
    }
    Timer{
        id: tInit
        running: false
        repeat: false
        onTriggered: an1.start()
    }
    Component.onCompleted: {
        if(!animationEnabled)return
        var min = 0
        var max = 4
        let seconds   = Math.floor(Math.random()*(max-min+1)+min);
        console.log('UxBotRect: '+unikSettings.lang)
        tInit.interval = seconds*1000
        tInit.start()
    }
}
